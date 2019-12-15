---
layout: post
title:  "Cheap Kubernetes Cluster with GCP for Learning/Hobbie - Part 2"
author: sal
categories: [ kubernetes, gcp ]
tags: [kubernetes, gcp, kubeip, affordablekubernetes, otladeps]
image: assets/images/22.jpg
description: "How to create Cheap Kubernetes Cluster with GCP for Learning/Hobbie."
featured: true
hidden: false
comments: false
toc: true
---

### Recap
In the last post we saw the difference between normal Kubernetes cluster and cheap or affordable Kubernetes cluster for learning or hobbies projects. 
The normal cluster was costing around USD 30 per month and for affordable cluster it was around USD 8 per month.


### Agenda
+ Create GCP project
+ Create Kubernetes Cluster
+ Configure Kubernetes CLuster
+ Assign Public Static IP for cluster nodes

### Google Cloud Platform Project

Once you login to GCP console using link `https://console.cloud.google.com` on the top of the screen you will abel to select existing project or create new project. 

![GCPProject]({{ site.baseurl }}/assets/images/2-1.PNG)

### Kubernetes Cluster

Under GCP menu search for `Kubernetes Engine` and select `Create Cluster` option to create a new cluster.

```Name```: Provide a desired name for the cluster 

```Location Type```: There are two Location type in GCP, Zonal and Regional. 
+ Zonal location type is used to deploy your application in one particular region 
+ Regional location type is used when you want to create deploy your application across multiple regions in the respective zone

For this tutorial we will deploy our cluster in only one region. Select the region which is nearest for you or your application audience.

![GCPProject]({{ site.baseurl }}/assets/images/2-2.PNG)

```Master Version```:Don't change the Master version of the Kubernetes cluster, by default it will select stable version.

```Node Pool```: Provide the required number of nodes required to create a cluster under default pool. Please note the minimum number of nodes should be 3 for the machine type preemptiable

```Machine Family``` Under more options select machine type as `fi-micro` where you will get one vCPU and 614 MB of RAM for every node and reduce the `Boot disk size` to 10GB from default 100GB. If you select 100GB Boot disk then cost of disk will be more than VM cost. Make sure you select preemptible nodes.

![GCPProject]({{ site.baseurl }}/assets/images/2-3.PNG)

Finally click on `Create`. It will take couple of minutes to create Kubernetes cluster. Coffee break!!

### Cluster Configuration

As we wanted to use our cluster resource as much as we can, we have to remove service which are not critical to run our cluster example logging. In editable mode disable `Stackdriver Kubernetes Engine Monitoring` and `Legacy Stackdriver Monitoring`

![GCPProject]({{ site.baseurl }}/assets/images/2-4.PNG)

### Connection to the cluster

To connect to Kubernets cluster and deploy application you need below softwares to be installed on your computer
+ GCP CLI - GCLOUD
+ Kubectl - Client cli application for Kubernets cluster

To download and configure GCP cli application follow the link [GCP CLI Install](https://cloud.google.com/sdk/install){:target="_blank"}

To download kubectl on your computer follow the link [Kubectl Install](https://kubernetes.io/docs/tasks/tools/install-kubectl/){:target="_blank"}

Once both the software are installed copy the gcould command from GCP console after you click on `Connect` button and execute on command promot

![GCPProject]({{ site.baseurl }}/assets/images/2-5.PNG)

To test kubectl is working, execute below command
```
kubectl get pods --all-namespaces
```
You should see output similar to below screenshot
![GCPProject]({{ site.baseurl }}/assets/images/2-6.PNG)

### Assign Public Static IP for cluster nodes

To assign the static IP to the cluster nodes we will use ```KubeIP``` from [KubeIP](https://github.com/doitintl/kubeip/). As we have created our cluster with preemptiable machine type, it will be alive for only 24hrs for this reason we need to monitor cluster node change event type and assign static IP for the same.

Execute the below commands by replacing the correct values where you see `<>` step by step on linux commands supported terminal. Windows user can use git bash terminal to execute the same

```
PROJECT_ID=<paste your project id from GCP console>
CLUSTER_NAME=<paste here your cluster name>
POOL_NAME=<default-pool or paste here pool name>
REGION_NAME=<paste here region name>

#Clone KubeIP GIT repository
git clone https://github.com/doitintl/kubeip.git

#Create service account in GCP called "kubeIP"
gcloud iam service-accounts create kubeip-service-account --display-name "kubeIP"

#Create role to access compute engine and external IP
gcloud iam roles create kubeip --project $PROJECT_ID --file roles.yaml

#Assign role to service account
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:kubeip-service-account@$PROJECT_ID.iam.gserviceaccount.com --role projects/$PROJECT_ID/roles/kubeip

#Get key for created service account
gcloud iam service-accounts keys create key.json --iam-account kubeip-service-account@$PROJECT_ID.iam.gserviceaccount.com

#Create Kubernetes cluster secret using key.json obtained from above step
kubectl create secret generic kubeip-key --from-file=key.json -n kube-system

#Create Cluster Role binding for your user(GCP email address)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user <GCP email address>

#Create Static IP
gcloud compute addresses create kubeip-ip1 --project=$PROJECT_ID --region=$REGION_NAME

#Add label to created static ip
gcloud beta compute addresses update kubeip-ip1 --update-labels kubeip=$CLUSTER_NAME --region $REGION_NAME

#Update Cluster name and pool name in Kubernetes deployment scripts
sed -i "s/reserved/$CLUSTER_NAME/g" deploy/kubeip-configmap.yaml
sed -i "s/default-pool/$POOL_NAME/g" deploy/kubeip-configmap.yaml
sed -i "s/pool-kubip/$POOL_NAME/g" deploy/kubeip-deployment.yaml

#Install deployment script to Kubernets Cluster using kubectl client
kubectl apply -f deploy/.
```
If you execute the commands succesfully without any error, you should see output of command ```kubectl get pods --all-namespaces``` similar to below screenshot
![GCPProject]({{ site.baseurl }}/assets/images/2-7.PNG)

You can also verify if the KubeIP assined static IP to one of your nodes under `Compute Engine -> VPC Network`

![GCPProject]({{ site.baseurl }}/assets/images/2-8.PNG)


### Video tutorial

<p><iframe style="width:100%;" height="500" src="https://www.youtube.com/embed/E5Fr2kn1oxw?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe></p>


### What Next???

Next i'll explain how to deploy sample application to Kubernetes cluster and access the application from browser.