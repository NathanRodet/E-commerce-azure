apiVersion: apps/v1
kind: Deployment
metadata:
  name: productcatalogservice
  labels: 
    app: productcatalogservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: productcatalogservice
  template:
    metadata:
      labels:
        app: productcatalogservice
    spec:
      containers:
      - name: productcatalogservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/productcatalogservice:COMMIT_SHA
        env:
        - name: PORT
          value: "3550"
        ports:
        - containerPort: 3550
---
kind: Service
apiVersion: v1
metadata:
  name: productcatalogservice
spec:
  selector:
    app: productcatalogservice
  ports:
  - protocol: TCP
    port: 3550
    targetPort: 3550
  type: ClusterIP