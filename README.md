# 🚀 EKS ADM Full

[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-326CE5?logo=kubernetes)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-FF4F8B?logo=argo)](https://argo-cd.readthedocs.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📌 Visão Geral

O **EKS ADM Full** é um projeto de **Infraestrutura como Código (IaC)** que provisiona e gerencia um cluster **Amazon EKS** completo utilizando **Terraform**.  
A solução segue práticas modernas de **GitOps** com **ArgoCD**, inclui **Karpenter** para provisionamento dinâmico de nós, e utiliza o **ALB Controller** para gerenciar ingressos no Kubernetes.  

---

## 🏗️ Arquitetura

```mermaid
flowchart TD
    subgraph AWS Cloud
        subgraph VPC
            EKS[(EKS Cluster)]
            Karpenter((Karpenter))
            ALB[ALB Controller]
            ArgoCD{{ArgoCD}}
        end
    end

    Dev[Desenvolvedor] -->|Git Push| GitHub[(GitHub Repo)]
    GitHub -->|Sync| ArgoCD
    ArgoCD -->|Deploy| EKS
    EKS -->|AutoScale| Karpenter
    EKS -->|Ingress| ALB
```

---

## 📂 Estrutura do Repositório

```
eks-adm-full/
│── modules/               # Módulos Terraform reutilizáveis
│   ├── alb-controller/    # Configuração do AWS ALB Ingress Controller
│   ├── argocd/            # Configuração do ArgoCD
│   ├── eks/               # Criação do cluster EKS
│   ├── karpenter/         # Configuração do Karpenter
│   ├── kube-stack/        # Componentes básicos do Kubernetes
│   ├── vpc/               # Rede (VPC, subnets, roteamento, etc.)
│
│── hom.tfvars             # Variáveis para ambiente de homologação
│── prod.tfvars            # Variáveis para ambiente de produção
│── main.tf                # Chama os módulos principais
│── provider.tf            # Configuração do provedor AWS
│── variables.tf           # Declaração de variáveis globais
│── inflaye.yaml           # Manifestos adicionais de configuração
```

---

## 🚀 Pré-requisitos

- Conta AWS configurada com permissões administrativas  
- Terraform >= 1.5.x  
- kubectl configurado  
- Helm 3 instalado  

Login na AWS (exemplo com AWS CLI):
```bash
aws configure
```

---

## ⚙️ Deploy

### 1. Inicializar o Terraform
```bash
terraform init
```

### 2. Criar e selecionar o workspace do ambiente

- Para **homologação**:
```bash
terraform workspace new hom || terraform workspace select hom
```

- Para **produção**:
```bash
terraform workspace new prod || terraform workspace select prod
```

### 3. Aplicar para homologação
```bash
terraform apply -var-file=hom.tfvars
```

### 4. Aplicar para produção
```bash
terraform apply -var-file=prod.tfvars
```

---

## 🔧 Customização

- Ajuste os parâmetros de subnets, CIDRs e regiões nos arquivos `*.tfvars`.  
- Modifique os módulos dentro de `modules/` para adequar políticas de IAM, versões do Kubernetes e recursos adicionais.  
- O `karpenter` substitui o Cluster Autoscaler e pode ser configurado para Spot e On-Demand instances.  

---

## 📊 Roadmap

- [x] Módulo de VPC  
- [x] Módulo de EKS  
- [x] Módulo de Karpenter  
- [x] Módulo de ALB Controller  
- [x] Integração com ArgoCD  
- [ ] Observabilidade (Prometheus + Grafana)  
- [ ] CI/CD Pipeline automatizado  

---

## 📜 Licença

Este projeto é distribuído sob a licença **MIT**.  
Sinta-se livre para usar, modificar e contribuir.  

---

👉 [Repositório GitHub](https://github.com/wallafidevops/eks-adm-full)
