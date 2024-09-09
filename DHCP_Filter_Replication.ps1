# DHCPサーバ 1号機 FQDN名
$DHCP_SV1 = "dhcp01.example.local"

# DHCPサーバ 2号機 FQDN名
$DHCP_SV2 = "dhcp02.example.local"

$DHCP_SV1_DENY_LIST = Get-DhcpServerv4Filter -ComputerName $DHCP_SV1 -List Deny
$DHCP_SV2_DENY_LIST = Get-DhcpServerv4Filter -ComputerName $DHCP_SV2 -List Deny

$AddMacList = New-Object System.Collections.ArrayList
$DelMacList = New-Object System.Collections.ArrayList

# 追加用 MACアドレスリスト作成
foreach($DENY in $DHCP_SV1_DENY_LIST) {
   if($DHCP_SV2_DENY_LIST.MacAddress -notcontains $DENY.MacAddress ) {
     [void]$AddMacList.Add($DENY)
   }
}

# 削除用 MACアドレスリスト作成
foreach($DENY in $DHCP_SV2_DENY_LIST) {
   if($DHCP_SV1_DENY_LIST.MacAddress -notcontains $DENY.MacAddress ) {
     [void]$DelMacList.Add($DENY)
   }
}

# DHCPサーバ 2号機へ新しいMACアドレス拒否フィルタを追加
$AddMacList | Add-DhcpServerv4Filter -ComputerName $DHCP_SV2 -List Deny

# DHCPサーバ 2号機から不要になったMACアドレス拒否フィルタを削除
$DelMacList | Remove-DhcpServerv4Filter -ComputerName $DHCP_SV2
