#!/bin/bash

set -e

####################################################
# Update Packages
####################################################

apt-get update -y

####################################################
# Install Apache
####################################################

apt-get install -y apache2 curl

systemctl enable apache2
systemctl start apache2

####################################################
# Collect System Information
####################################################

HOSTNAME=$(hostname)

OS=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

KERNEL=$(uname -r)

ARCH=$(uname -m)

UPTIME=$(uptime -p)

APACHE_VERSION=$(apache2 -v | head -1 | cut -d: -f2 | xargs)

####################################################
# AWS Metadata (IMDSv2)
####################################################

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token:$TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id -s)

INSTANCE_TYPE=$(curl -H "X-aws-ec2-metadata-token:$TOKEN" \
http://169.254.169.254/latest/meta-data/instance-type -s)

AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token:$TOKEN" \
http://169.254.169.254/latest/meta-data/placement/availability-zone -s)

REGION=$(echo $AVAILABILITY_ZONE | sed 's/[a-z]$//')

PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token:$TOKEN" \
http://169.254.169.254/latest/meta-data/local-ipv4 -s)

####################################################
# Create Landing Page
####################################################

cat <<EOF >/var/www/html/index.html
<!DOCTYPE html>
<html>

<head>

<title>AWS Two-Tier Infrastructure</title>

<style>

body{
margin:0;
padding:0;
background:#232F3E;
font-family:Arial,sans-serif;
color:white;
}

.container{
width:90%;
margin:auto;
padding:40px;
text-align:center;
}

h1{
color:#FF9900;
}

.card{
background:#37475A;
padding:25px;
border-radius:10px;
margin-top:30px;
box-shadow:0 0 15px rgba(0,0,0,0.4);
}

table{
width:100%;
border-collapse:collapse;
margin-top:20px;
}

td{
padding:14px;
border:1px solid #555;
text-align:left;
}

tr:nth-child(even){
background:#2c3b4f;
}

.footer{
margin-top:40px;
font-size:18px;
}

</style>

</head>

<body>

<div class="container">

<h1>🚀 AWS Two-Tier Infrastructure using Terraform</h1>

<h2>Deployment Successful</h2>

<div class="card">

<table>

<tr>
<td><b>Hostname</b></td>
<td>$HOSTNAME</td>
</tr>

<tr>
<td><b>Operating System</b></td>
<td>$OS</td>
</tr>

<tr>
<td><b>Kernel</b></td>
<td>$KERNEL</td>
</tr>

<tr>
<td><b>Architecture</b></td>
<td>$ARCH</td>
</tr>

<tr>
<td><b>Apache Version</b></td>
<td>$APACHE_VERSION</td>
</tr>

<tr>
<td><b>Uptime</b></td>
<td>$UPTIME</td>
</tr>

<tr>
<td><b>AWS Region</b></td>
<td>$REGION</td>
</tr>

<tr>
<td><b>Availability Zone</b></td>
<td>$AVAILABILITY_ZONE</td>
</tr>

<tr>
<td><b>Instance ID</b></td>
<td>$INSTANCE_ID</td>
</tr>

<tr>
<td><b>Instance Type</b></td>
<td>$INSTANCE_TYPE</td>
</tr>

<tr>
<td><b>Private IP</b></td>
<td>$PRIVATE_IP</td>
</tr>

<tr>
<td><b>Provisioning Tool</b></td>
<td>Terraform</td>
</tr>

<tr>
<td><b>Web Server</b></td>
<td>Apache2</td>
</tr>

<tr>
<td><b>Architecture</b></td>
<td>ALB + Auto Scaling + RDS MySQL</td>
</tr>

</table>

</div>

<div class="footer">

<p>Designed & Provisioned by Terraform</p>

<h2>Kshitij Shrivastava</h2>

</div>

</div>

</body>

</html>

EOF

####################################################
# Restart Apache
####################################################

systemctl restart apache2

echo "Deployment completed successfully."