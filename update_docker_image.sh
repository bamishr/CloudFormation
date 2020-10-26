 # redis-security-group.yaml
AWSTemplateFormatVersion: "2010-09-09"
Parameters:
  BastionAccessSecurityGroup:
    Type: "String"
  Environment:
    Type: "String"
  ImageId:
    Type: "String"
  KeyName:
    Type: "String"
  VpcId:
    Type: "String"

Resources:
  RedisSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      VpcId:
        Ref: "VpcId"
      GroupDescription: "A component security group allowing access only to redis"
  ElasticacheComponentSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      GroupDescription: "Elasticache security group"
      SecurityGroupIngress:
        -
          IpProtocol: "tcp"
          FromPort: "6379"
          ToPort: "6379"
          SourceSecurityGroupId:
            Ref: RedisSecurityGroup
      VpcId:
        Ref: "VpcId"

#################################################################################
# main.yaml (need to have Redis Security Group)
  ComponentLaunchConfiguration:
    Type: "AWS::AutoScaling::LaunchConfiguration"
    Properties:
      KeyName:
        Ref: "KeyName"
      SecurityGroups:
        -
          Ref: "BastionAccessSecurityGroup"
        -
          Ref: "ComponentSecurityGroup"
        -
          Ref: "RedisSecurityGroup"
      InstanceType:
        Ref: "InstanceType"
      IamInstanceProfile:
        Ref: "ComponentInstanceProfile"
      ImageId:
        Ref: "ImageId"

#################################################################################
# elasticache.yaml
---
  Parameters:
    BastionAccessSecurityGroup:
      Type: "String"
    ClusterName:
      Type: "String"
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    Environment:
      Type: "String"
    ImageId:
      Type: "String"
    KeyName:
      Type: "String"
    NumCacheNodes:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    VpcId:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceComponentElasticache:
      Type: "AWS::ElastiCache::CacheCluster"
      Properties:
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        ClusterName:
          Ref: ClusterName
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheNodes:
          Ref: NumCacheNodes
        SnapshotRetentionLimit: 1
        VpcSecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup

#################################################################################
# replication.yaml
---
  Parameters:
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    NumCacheClusters:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    ReplicationGroupDescription:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceReplicationGroup:
      Type: "AWS::ElastiCache::ReplicationGroup"
      Properties:
        AutomaticFailoverEnabled: false
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheClusters:
          Ref: NumCacheClusters
        Port: 6379
        ReplicationGroupDescription:
          Ref: ReplicationGroupDescription
        SecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup 
 # redis-security-group.yaml
AWSTemplateFormatVersion: "2010-09-09"
Parameters:
  BastionAccessSecurityGroup:
    Type: "String"
  Environment:
    Type: "String"
  ImageId:
    Type: "String"
  KeyName:
    Type: "String"
  VpcId:
    Type: "String"

Resources:
  RedisSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      VpcId:
        Ref: "VpcId"
      GroupDescription: "A component security group allowing access only to redis"
  ElasticacheComponentSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      GroupDescription: "Elasticache security group"
      SecurityGroupIngress:
        -
          IpProtocol: "tcp"
          FromPort: "6379"
          ToPort: "6379"
          SourceSecurityGroupId:
            Ref: RedisSecurityGroup
      VpcId:
        Ref: "VpcId"

#################################################################################
# main.yaml (need to have Redis Security Group)
  ComponentLaunchConfiguration:
    Type: "AWS::AutoScaling::LaunchConfiguration"
    Properties:
      KeyName:
        Ref: "KeyName"
      SecurityGroups:
        -
          Ref: "BastionAccessSecurityGroup"
        -
          Ref: "ComponentSecurityGroup"
        -
          Ref: "RedisSecurityGroup"
      InstanceType:
        Ref: "InstanceType"
      IamInstanceProfile:
        Ref: "ComponentInstanceProfile"
      ImageId:
        Ref: "ImageId"

#################################################################################
# elasticache.yaml
---
  Parameters:
    BastionAccessSecurityGroup:
      Type: "String"
    ClusterName:
      Type: "String"
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    Environment:
      Type: "String"
    ImageId:
      Type: "String"
    KeyName:
      Type: "String"
    NumCacheNodes:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    VpcId:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceComponentElasticache:
      Type: "AWS::ElastiCache::CacheCluster"
      Properties:
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        ClusterName:
          Ref: ClusterName
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheNodes:
          Ref: NumCacheNodes
        SnapshotRetentionLimit: 1
        VpcSecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup

#################################################################################
# replication.yaml
---
  Parameters:
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    NumCacheClusters:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    ReplicationGroupDescription:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceReplicationGroup:
      Type: "AWS::ElastiCache::ReplicationGroup"
      Properties:
        AutomaticFailoverEnabled: false
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheClusters:
          Ref: NumCacheClusters
        Port: 6379
        ReplicationGroupDescription:
          Ref: ReplicationGroupDescription
        SecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup 
 # redis-security-group.yaml
AWSTemplateFormatVersion: "2010-09-09"
Parameters:
  BastionAccessSecurityGroup:
    Type: "String"
  Environment:
    Type: "String"
  ImageId:
    Type: "String"
  KeyName:
    Type: "String"
  VpcId:
    Type: "String"

Resources:
  RedisSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      VpcId:
        Ref: "VpcId"
      GroupDescription: "A component security group allowing access only to redis"
  ElasticacheComponentSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      GroupDescription: "Elasticache security group"
      SecurityGroupIngress:
        -
          IpProtocol: "tcp"
          FromPort: "6379"
          ToPort: "6379"
          SourceSecurityGroupId:
            Ref: RedisSecurityGroup
      VpcId:
        Ref: "VpcId"

#################################################################################
# main.yaml (need to have Redis Security Group)
  ComponentLaunchConfiguration:
    Type: "AWS::AutoScaling::LaunchConfiguration"
    Properties:
      KeyName:
        Ref: "KeyName"
      SecurityGroups:
        -
          Ref: "BastionAccessSecurityGroup"
        -
          Ref: "ComponentSecurityGroup"
        -
          Ref: "RedisSecurityGroup"
      InstanceType:
        Ref: "InstanceType"
      IamInstanceProfile:
        Ref: "ComponentInstanceProfile"
      ImageId:
        Ref: "ImageId"

#################################################################################
# elasticache.yaml
---
  Parameters:
    BastionAccessSecurityGroup:
      Type: "String"
    ClusterName:
      Type: "String"
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    Environment:
      Type: "String"
    ImageId:
      Type: "String"
    KeyName:
      Type: "String"
    NumCacheNodes:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    VpcId:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceComponentElasticache:
      Type: "AWS::ElastiCache::CacheCluster"
      Properties:
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        ClusterName:
          Ref: ClusterName
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheNodes:
          Ref: NumCacheNodes
        SnapshotRetentionLimit: 1
        VpcSecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup

#################################################################################
# replication.yaml
---
  Parameters:
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    NumCacheClusters:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    ReplicationGroupDescription:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceReplicationGroup:
      Type: "AWS::ElastiCache::ReplicationGroup"
      Properties:
        AutomaticFailoverEnabled: false
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheClusters:
          Ref: NumCacheClusters
        Port: 6379
        ReplicationGroupDescription:
          Ref: ReplicationGroupDescription
        SecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup 
 # redis-security-group.yaml
AWSTemplateFormatVersion: "2010-09-09"
Parameters:
  BastionAccessSecurityGroup:
    Type: "String"
  Environment:
    Type: "String"
  ImageId:
    Type: "String"
  KeyName:
    Type: "String"
  VpcId:
    Type: "String"

Resources:
  RedisSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      VpcId:
        Ref: "VpcId"
      GroupDescription: "A component security group allowing access only to redis"
  ElasticacheComponentSecurityGroup:
    Type: "AWS::EC2::SecurityGroup"
    Properties:
      GroupDescription: "Elasticache security group"
      SecurityGroupIngress:
        -
          IpProtocol: "tcp"
          FromPort: "6379"
          ToPort: "6379"
          SourceSecurityGroupId:
            Ref: RedisSecurityGroup
      VpcId:
        Ref: "VpcId"

#################################################################################
# main.yaml (need to have Redis Security Group)
  ComponentLaunchConfiguration:
    Type: "AWS::AutoScaling::LaunchConfiguration"
    Properties:
      KeyName:
        Ref: "KeyName"
      SecurityGroups:
        -
          Ref: "BastionAccessSecurityGroup"
        -
          Ref: "ComponentSecurityGroup"
        -
          Ref: "RedisSecurityGroup"
      InstanceType:
        Ref: "InstanceType"
      IamInstanceProfile:
        Ref: "ComponentInstanceProfile"
      ImageId:
        Ref: "ImageId"

#################################################################################
# elasticache.yaml
---
  Parameters:
    BastionAccessSecurityGroup:
      Type: "String"
    ClusterName:
      Type: "String"
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    Environment:
      Type: "String"
    ImageId:
      Type: "String"
    KeyName:
      Type: "String"
    NumCacheNodes:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    VpcId:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceComponentElasticache:
      Type: "AWS::ElastiCache::CacheCluster"
      Properties:
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        ClusterName:
          Ref: ClusterName
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheNodes:
          Ref: NumCacheNodes
        SnapshotRetentionLimit: 1
        VpcSecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup

#################################################################################
# replication.yaml
---
  Parameters:
    CacheNodeType:
      Type: "String"
    CacheSubnetGroupName:
      Type: "String"
    ElasticacheComponentSecurityGroup:
      Type: "String"
    NumCacheClusters:
      Type: "String"
    PrivateSubnet1Id:
      Type: "String"
    PrivateSubnet2Id:
      Type: "String"
    PrivateSubnet3Id:
      Type: "String"
    PublicSubnet1Id:
      Type: "String"
    PublicSubnet2Id:
      Type: "String"
    PublicSubnet3Id:
      Type: "String"
    ReplicationGroupDescription:
      Type: "String"

  Resources:
    CacheSubnetGroup:
      Type: "AWS::ElastiCache::SubnetGroup"
      Properties:
        Description:
          Ref: CacheSubnetGroupName
        SubnetIds:
          -
            Ref: PrivateSubnet1Id
          -
            Ref: PrivateSubnet2Id
          -
            Ref: PrivateSubnet3Id
          -
            Ref: PublicSubnet1Id
          -
            Ref: PublicSubnet2Id
          -
            Ref: PublicSubnet3Id
    DefaultParametersGroup:
      Type: "AWS::ElastiCache::ParameterGroup"
      Properties:
        CacheParameterGroupFamily: "redis2.8"
        Description: "Modifications to support better performance"
        Properties:
          tcp-keepalive: 60
          timeout: 900
    ServiceReplicationGroup:
      Type: "AWS::ElastiCache::ReplicationGroup"
      Properties:
        AutomaticFailoverEnabled: false
        CacheNodeType:
          Ref: CacheNodeType
        CacheParameterGroupName:
          Ref: DefaultParametersGroup
        CacheSubnetGroupName:
          Ref: CacheSubnetGroup
        Engine: "redis"
        EngineVersion: "2.8.21"
        NumCacheClusters:
          Ref: NumCacheClusters
        Port: 6379
        ReplicationGroupDescription:
          Ref: ReplicationGroupDescription
        SecurityGroupIds:
          -
            Ref: ElasticacheComponentSecurityGroup 
