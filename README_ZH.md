<p align="center">
  <h1 align="center">SNMP Exporter Prometheus网络设备监控</h1>
  <p align="center">
    <a href="README.md"><strong>English</strong></a> | <strong>简体中文</strong>
  </p>
</p>

## 目录

- [仓库简介](#项目介绍)
- [前置条件](#前置条件)
- [镜像说明](#镜像说明)
- [获取帮助](#获取帮助)
- [如何贡献](#如何贡献)

## 项目介绍
‌[SNMP Exporter‌](https://github.com/prometheus/snmp_exporter) SNMP Exporter 是 Prometheus 生态的官方组件，用于通过 ‌SNMP 协议‌（Simple Network Management Protocol）采集网络设备（如交换机、路由器、防火墙等）的监控指标，并将其转换为 Prometheus 兼容的时序数据格式‌。

**核心特性：**
1. 协议转换桥接：核心功能是将 SNMP（简单网络管理协议）设备查询的 OID 数据，转换为 Prometheus 可抓取和识别的 metrics 格式（HTTP/HTTPS）。它作为传统网络设备监控与现代云原生监控体系之间的关键桥梁。
2. 灵活的生成器架构：采用基于 generator.yml 配置文件和 MIB（管理信息库）文件的生成器模式。用户无需编写代码，只需在 YAML 中定义所需采集的 OID 及其映射关系，即可自动编译生成最终的 snmp.yml 配置文件，极大简化了复杂设备的监控配置。
3. 强大的指标映射：支持将 SNMP 查询结果（标量值、表格数据）智能映射为 Prometheus 的指标格式（Gauge, Counter, Histogram 等）。例如，能将接口表（IF-MIB）中的 ifInOctets 和 ifDescr 自动转换为带 ifIndex、ifDescr 标签的矢量指标 snmp_if_in_octets。
4. 自动发现与指标生成：通过 walk 操作自动发现设备支持的 OID，并支持通过 walk 生成初始的生成器配置文件骨架，大幅减少手动查找和配置 OID 的工作量，降低配置门槛。
5. 高度可配置的过滤与重命名： 支持在生成器和采集器配置中对 OID 进行过滤，只采集需要的指标。同时，支持对指标名称（metric name）和标签键（label key）进行重命名，使其更符合 Prometheus 的命名规范且更易读。
6. 多设备模块化配置：支持为不同品牌、型号的设备（如 Cisco, Juniper, F5 等）预定义和复用不同的配置模块（modules）。通过在主配置中指定目标设备使用的模块，即可实现一套 Exporter 监控多种异构网络设备。
7. 高效批量数据收集：支持通过 GETBULK 操作批量获取 SNMP 表数据，相比传统的逐项 GETNEXT 查询，能极大减少查询次数和网络往返开销，显著提升采集效率，尤其适用于包含大量条目的表（如路由表、ARP 表）。
8. 安全性与多版本支持：支持 SNMP v1, v2c, v3 多种协议版本。对 SNMP v3 提供了完整支持，包括身份验证（MD5, SHA）和加密（DES, AES）功能，满足不同网络环境的安全要求。

本项目提供的开源镜像商品 [**`SNMP Exporter-Prometheus网络设备监控`**]()，已预先安装 SNMP Exporter 软件及其相关运行环境，并提供部署模板。快来参照使用指南，轻松开启“开箱即用”的高效体验吧。

**架构设计：**

![](./images/img.png)

> **系统要求如下：**
> - CPU: 4vCPUs 或更高
> - RAM: 16GB 或更大
> - Disk: 至少 50GB

## 前置条件
[注册华为账号并开通华为云](https://support.huaweicloud.com/usermanual-account/account_id_001.html)

## 镜像说明

| 镜像规格                                                                                                                                                              | 特性说明 | 备注 |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------| --- | --- |
| [SNMPExporter0.28.0-kunpeng-v1.0](https://github.com/HuaweiCloudDeveloper/prometheus-snmp-exporter-image/tree/SNMPExporter0.28.0-kunpeng-v1.0?tab=readme-ov-file) | 基于鲲鹏服务器 + Huawei Cloud EulerOS 2.0 64bit 安装部署 |  |

## 获取帮助
- 更多问题可通过 [issue](https://github.com/HuaweiCloudDeveloper/prometheus-snmp-exporter-image/issues) 或 华为云云商店指定商品的服务支持 与我们取得联系
- 其他开源镜像可看 [open-source-image-repos](https://github.com/HuaweiCloudDeveloper/open-source-image-repos)

## 如何贡献
- Fork 此存储库并提交合并请求
- 基于您的开源镜像信息同步更新 README.md