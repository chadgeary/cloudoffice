resource "oci_identity_dynamic_group" "nc-id-dynamic-group" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-dynamic-group"
  description             = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule           = "All {instance.compartment.id = '${oci_identity_compartment.nc-compartment.id}'}"
}

resource "oci_identity_policy" "nc-id-storage-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-policy"
  description             = "Identity Policy for instance to use object storage encryption"
  statements              = ["Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use secret-family in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use vaults in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to manage object-family in compartment id ${oci_identity_compartment.nc-compartment.id} where target.bucket.name='${var.nc_prefix}-bucket'"]
}

resource "oci_identity_policy" "nc-id-disk-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-disk-policy"
  description             = "Identity Policy for disk encryption"
  statements              = ["Allow service blockstorage to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-disk-vault.id}'"]
}

resource "oci_identity_policy" "nc-id-storageobject-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-storageobject-policy"
  description             = "Identity Policy for objectstorage service"
  statements              = ["Allow service objectstorage-${var.oci_region} to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'"]
}
