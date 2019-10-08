---
layout: post
title:  "Cheap Kubernetes Cluster with GCP for Learning/Hobbie - Part 1"
author: sal
categories: [ kubernetes, gcp ]
tags: [kubernetes, gcp]
image: assets/images/11.jpg
description: "How to create Cheap Kubernetes Cluster with GCP for Learning/Hobbie."
featured: true
hidden: false
comments: false
toc: true
---

### What is Kubernetes?
Kubernets is a open source platform for managing containerized application. The name Kubernetes originates from Greek, meaning helmsman or pilot. Google open sourced the project in 2014.


#### Kubernetes Cluster cost on cloud
To setup Kubernetes cluster we need Master VM or Control panel, minimum we need 3 workers or node VM's. If we are creating cluster on cloud, master/control panel is free of cost. The only cost we have to bear is 3 nodes.

For 3 VM's on Google Cloud Platform we need to pay around USD 15 per month and we need one load balancer to access application from Internet. The cost for Load Balancer is around USD 22 per month, which is more than 3 VM's. Total USD approx. USD 37 per month, which is expensive to learn/try Kubernetes cluster on cloud.

![GCPPrice]({{ site.baseurl }}/assets/images/1-1.PNG)



#### Cheap Kubernetes Cluster on GCP
As explained above, we need 3 VM's for our cluster to up and running. We can also use only one VM to run Kubernetes cluster, but we can't guaranty that it's availability is 99.9%.
GCP provides VM with almost half the price of normal VM which is called Preemptible. Preemptible VM's are removed every 24hours and new VM gets allocated within couple of seconds. The cost of 3 preemptible VM's is USD 9. We also don't need load balancer, i'll explain you the trick to access your application without load balancer.

![GCPPrice]({{ site.baseurl }}/assets/images/1-2.PNG)


### Video tutorial

<p><iframe style="width:100%;" height="500" src="https://www.youtube.com/embed/kjtw4iEFMdc?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe></p>


### What Next???

Next i'll explain how to create Kubernetes cluster on Google Cloud Platform and will explain how to login to cluster using kubectl client application.