package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

// Integration test - uses the examples/dns-records configuration
func TestDNSRecordsIntegration(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/dns-records",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Get the outputs
	records := terraform.OutputMap(t, terraformOptions, "records")

	// Verify that we have the expected number of records
	assert.Equal(t, 4, len(records), "Should have 4 DNS records")

	// Verify specific records exist
	assert.Contains(t, records, "tmp.aws.dmfigol.me|A", "Should have A record")
	assert.Contains(t, records, "tmp.aws.dmfigol.me|AAAA", "Should have AAAA record")
	assert.Contains(t, records, "tmp-cname.aws.dmfigol.me", "Should have CNAME record")
	assert.Contains(t, records, "tmp-alias.aws.dmfigol.me", "Should have alias record")
}

// Unit tests - use different tfvars files for different test scenarios
func TestDNSRecordsBasicFunctionality(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"basic-functionality.tfvars"},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Get the outputs
	records := terraform.OutputMap(t, terraformOptions, "records")

	// Verify that we have the expected number of records
	assert.Equal(t, 2, len(records), "Should have 2 DNS records")

	// Verify specific records exist
	assert.Contains(t, records, "test-a.example.com", "Should have A record")
	assert.Contains(t, records, "test-cname.example.com", "Should have CNAME record")
}

func TestDNSRecordsValidationBothRecordsAndAlias(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-both-records-and-alias.tfvars"},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	// Check for the validation error message (handling line breaks in Terraform output)
	assert.Contains(t, err.Error(), "Each DNS record must have either 'records' or 'alias' specified")
	assert.Contains(t, err.Error(), "but not both.")
}

func TestDNSRecordsValidationMissingRecordsAndAlias(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-missing-records-and-alias.tfvars"},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "Each DNS record must have either 'records' or 'alias' specified, but not both.")
}

func TestDNSRecordsValidationInvalidType(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-invalid-type.tfvars"},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "Record type must be one of: A, AAAA, CNAME, MX, TXT, PTR, SRV, SOA, NS.")
}

func TestDNSRecordsValidationMissingZone(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-missing-zone.tfvars"},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "Zone is required for all DNS records.")
}

func TestDNSRecordsValidationInvalidZoneType(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-invalid-zone-type.tfvars"},
	}

	_, err := terraform.InitAndPlanE(t, terraformOptions)
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "Zone type must be either 'public', 'private', or null (for auto-discovery).")
}

func TestDNSRecordsValidationMissingZoneExists(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-missing-zone-exists.tfvars"},
	}

	// For missing zones, the check should pass with a warning since we have zone_type logic
	// The test should verify that the warning is displayed but doesn't fail the plan
	_, err := terraform.InitAndPlanE(t, terraformOptions)
	// The plan should succeed, but we should check the output for the warning
	assert.NoError(t, err)
}

func TestDNSRecordsValidationAmbiguousZone(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-ambiguous-zone.tfvars"},
	}

	// For ambiguous zones, the check should pass with a warning since we have zone_type logic
	// The test should verify that the warning is displayed but doesn't fail the plan
	_, err := terraform.InitAndPlanE(t, terraformOptions)
	// The plan should succeed, but we should check the output for the warning
	assert.NoError(t, err)
}

func TestDNSRecordsValidationAmbiguousZoneFixed(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		VarFiles:     []string{"validation-ambiguous-zone-fixed.tfvars"},
	}

	// When zone_type is explicitly specified, there should be no ambiguous zone warning
	_, err := terraform.InitAndPlanE(t, terraformOptions)
	// The plan should succeed without any ambiguous zone warnings
	assert.NoError(t, err)
}
