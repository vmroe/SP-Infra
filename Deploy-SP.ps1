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

# Binaries
$NestedESXiApplianceOVA = 'C:\Nested-SDDC\Nested_ESXi6.7_Appliance_Template_v1.ova'
$VCSAInstallerPath = "C:\Nested-SDDC\VMware-VCSA-all-6.7.0-14836122"
$NSXOVA =  'C:\Nested-SDDC\VMware-NSX-Manager-6.4.6-14819921.ova'
$ESXi67OfflineBundle = 'C:\Nested-SDDC\update-from-esxi6.7-6.7_update03.zip' # Offline upgrade
$ESXiProfileName = 'ESXi-6.7.0-20191104001-standard	' # Online upgrade - Meer info: https://www.virten.net/vmware/vmware-esxi-image-profiles/#esxi6.7
$vCloudOVA = 'C:\Nested-SDDC\VMware_vCloud_Director-10.0.0.4471-14638910_OVF10.ova'
$vCavOVA = 'C:\Nested-SDDC\VMware-vCloud-Availability-3.5.0.4051-15038129_OVF10.ova'

# Details van het lab die je wil deployen
$PublicDomain = 'vcloud.domain.com' # Dit is de naam van de resource pool
$ADdomain = 'domain.local' # Microsoft Active Directory domein 
$NetBIOS = 'domain'
$VCSASSODomainName = "vsphere.local" # vSphere Single Sign-On domein
$Password_AD = "SafeP@ssword01"
$Password_vSphere = "SafeP@ssword01"
$Password_NSX = "SafeP@ssword01"
$Password_vCD = "SafeP@ssword01"
$Password_VCAV = "SafeP@ssword01"
$Subnet_LAN = '192.168.110'
$Subnet_DMZ = '172.16.100'
$Subnet_ESX = '192.168.111'
$Subnet_VXLAN = '192.168.111'
$NTPserver = 'pool.ntp.org'

# Static IP Config
$IP_MGMT01 = "$Subnet_LAN.100"
$IP_DC01 = "$Subnet_LAN.101"
$IP_DC02 = "$Subnet_LAN.102"
$IP_VCSA01 = "$Subnet_LAN.103"
$IP_NSX_MGMT01 = "$Subnet_LAN.104"
$IP_FS01 = "$Subnet_LAN.105"
$IP_VCDCELL01_UI = "$Subnet_LAN.106"
$IP_VCDCELL01_DB = "$Subnet_LAN.107"
$IP_VCDCELL02_UI = "$Subnet_LAN.108"
$IP_VCDCELL02_DB = "$Subnet_LAN.109"
$IP_VCDCELL03_UI = "$Subnet_LAN.110"
$IP_VCDCELL03_DB = "$Subnet_LAN.111"
$IP_ESX01 = "$Subnet_ESX.1"
$IP_ESX02 = "$Subnet_ESX.2"
$IP_ESX03 = "$Subnet_ESX.3"

$SubnetMask_24 = '255.255.255.0'

$GW_LAN = "$Subnet_LAN.254"
$GW_DMZ = "$Subnet_DMZ.254"
$GW_ESX = "$Subnet_ESX.254"

$IP_DNS1 = $IP_DC01
$IP_DNS2 = $IP_DC02

# Virtuele resources
$DC01 = "dc01.$ADdomain"
$DC02 = "dc02.$ADdomain"
$FS01 = "fs01.$ADdomain"
$MGMT01 = "mgmt01.$ADdomain"
$NameVCDCELL01 = "vcd-cell01.$ADdomain"
$NameVCDCELL02 = "vcd-cell02.$ADdomain"
$NameVCDCELL03 = "vcd-cell03.$ADdomain"
$NameVCAVMGMT01 = "vcav-mgmt01.$ADdomain"
$NameVCAVREPLICATOR01 = "vcav-replicator01.$ADdomain"
$NameVCAVTUNNEL01 = "vcav-tunnel01.$ADdomain"
$NameNSX_MGMT01 = "nsx-mgmt.$ADdomain"
$NameVCSA01 = "vcsa01.$ADdomain"
$NameDatacenter = "Datacenter.$ADdomain"
$NameCluster01 = "Cluster_01.$ADdomain"
$NestedESXiHostnameToIPs = @{
    "esx01.$ADdomain" = "$Subnet_ESX.1"
    "esx02.$ADdomain" = "$Subnet_ESX.2"
    "esx03.$ADdomain" = "$Subnet_ESX.3"
}


Doet ie het nu?