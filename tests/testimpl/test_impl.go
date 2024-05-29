package common

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/appmesh"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
	"github.com/aws/aws-sdk-go-v2/service/servicediscovery"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

func TestDoesEcsClusterExist(t *testing.T, ctx types.TestContext) {
	ecsClient := ecs.NewFromConfig(GetAWSConfig(t))
	resourceNames := terraform.OutputMap(t, ctx.TerratestTerraformOptions(), "resource_names")
	ecsClusterArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "fargate_arn")

	appmeshClient := appmesh.NewFromConfig(GetAWSConfig(t))
	serviceDisoveryClient := servicediscovery.NewFromConfig(GetAWSConfig(t))

	t.Run("TestDoesClusterExist", func(t *testing.T) {
		output, err := ecsClient.DescribeClusters(context.TODO(), &ecs.DescribeClustersInput{Clusters: []string{ecsClusterArn}})
		if err != nil {
			t.Errorf("Error getting cluster description: %v", err)
		}

		require.Equal(t, 1, len(output.Clusters), "Expected 1 cluster to be returned")
		require.Equal(t, ecsClusterArn, *output.Clusters[0].ClusterArn, "Expected cluster ARN to match")
		require.Equal(t, resourceNames["ecs_cluster"], *output.Clusters[0].ClusterName, "Expected cluster name to match")
	})

	t.Run("TestDoesAppMeshExist", func(t *testing.T) {
		appmeshName := resourceNames["app_mesh"]
		appmeshArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "app_mesh_arn")

		output, err := appmeshClient.DescribeMesh(context.TODO(), &appmesh.DescribeMeshInput{MeshName: &appmeshName})
		if err != nil {
			t.Errorf("Error getting mesh description: %v", err)
		}

		require.Equal(t, appmeshName, *output.Mesh.MeshName, "Expected mesh name to match")
		require.Equal(t, appmeshArn, *output.Mesh.Metadata.Arn, "Expected mesh ARN to match")
	})

	t.Run("TestDoesServiceDiscoveryNamespaceExist", func(t *testing.T) {
		serviceDiscoveryName := terraform.Output(t, ctx.TerratestTerraformOptions(), "namespace_name")
		serviceDiscoveryArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "namespace_arn")
		serviceDiscoveryId := terraform.Output(t, ctx.TerratestTerraformOptions(), "namespace_id")

		output, err := serviceDisoveryClient.GetNamespace(context.TODO(), &servicediscovery.GetNamespaceInput{Id: &serviceDiscoveryId})
		if err != nil {
			t.Errorf("Error getting namespace description: %v", err)
		}

		require.Equal(t, serviceDiscoveryName, *output.Namespace.Name, "Expected namespace name to match")
		require.Equal(t, serviceDiscoveryId, *output.Namespace.Id, "Expected namespace ID to match")
		require.Equal(t, serviceDiscoveryArn, *output.Namespace.Arn, "Expected namespace ARN to match")
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
