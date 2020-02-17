<#
PowerCLI
https://www.powershellgallery.com/packages/VMware.PowerCLI/11.5.0.14912921
#>

#���s�|���V�[�ݒ�
Set-ExecutionPolicy RemoteSigned

###����p�����[�^�[��`
#1
$old_vcenter = '192.168.20.97'
$old_admin = 'administrator'
$old_admin_pass = '!!!Password123'

$new_vcenter = '192.168.20.96'
$new_admin = 'administrator@vsphere.local'
$new_admin_pass = '!!!Password123'
$new_ds = 'datastore2'
$new_vmhost = '192.168.20.91'

# 
##2
#�G�N�X�|�[�g��̃p�X
$vm_export_path ='C:\export_vms'
#�G�N�X�|�[�g���鉼�z�}�V�����̔z��
$vm_target = 'ws2012_01','ws2012_02'
#
###

#PowerCLI�ݒ�11.5.0
$set_powercli = Set-PowerCLIConfiguration -Scope AllUsers -InvalidCertificateAction Ignore -ParticipateInCeip $false -Confirm:$false -WebOperationTimeoutSeconds 144000


foreach($i_vm in $vm_target)
{
    #��vCenter�ڑ�
    Connect-VIServer -Server $old_vcenter -Protocol https -User $old_admin -Password $old_admin_pass

    #VM�I�u�W�F�N�g�擾
    $vm = Get-VM -Name $i_vm -Server $old_vcenter

    #���z�}�V���G�N�X�|�[�g
    Export-VApp -Destination $vm_target -VM $vm -Format Ovf

    #��vCenter�ؒf
    Disconnect-VIServer -Server $old_vcenter -Force -Confirm:$false

    #�VvCenter�֐ڑ�
    Connect-VIServer -Server $new_vcenter -Protocol https -User $new_admin -Password $new_admin_pass

    #���z�}�V���C���|�[�g
    $myDatastore = Get-Datastore -Name $new_ds -Server $new_vcenter
    $vmHost = Get-VMHost -Name $new_vmhost
    $vmHost | Import-vApp -Source "C:\export_vms\ws2012_02\ws2012_02.ovf" -Datastore $myDatastore -Force

    #�VvCenter�ؒf
    Disconnect-VIServer -Server $new_vcenter -Force -Confirm:$false
}

