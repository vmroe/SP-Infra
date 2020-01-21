# Author: Marc Roeleveld
# Website: https://www.vblog.nl
# Notes:
# Script needs a vCenter Server

# Changelog:
# 2020.01.21 - Start

# Set PowerCLI configuration to accept invalid Certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User -ParticipateInCEIP $true

# Import Modules
Import-Module -Name PowerNSX
Import-Module -Name VMware.PowerCLI

# Destination to deploy Nested SP Infra
$VIServer = 'vcsa01.domain.local'
$VIUsername = 'administrator@vsphere.local'
$VIPassword = 'SafeP@ssword01'
$ESXi_Host = 'esx01.domain.local'
$VCSA_Datastore = 'vsanDatastore'
$VCSA_Cluster = 'Cluster01'
$Template_Win2019 = '_Template_Win2019'
$Portgroup_LAN = "PG_LAN"
$Portgroup_DMZ = "PG_DMZ"
$Portgroup_ESX = "PG_ESX"
