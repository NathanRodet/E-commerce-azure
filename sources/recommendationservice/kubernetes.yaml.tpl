apiVersion: apps/v1
kind: Deployment
metadata:
  name: recommendationservice
  labels: 
    app: recommendationservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: recommendationservice
  template:
    metadata:
      labels:
        app: recommendationservice
    spec:
      containers:
      - name: recommendationservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/recommendationservice:COMMIT_SHA
        env:
        - name: PORT
          value: "8080"
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        ports:
        - containerPort: 8080
---
kind: Service
apiVersion: v1
metadata:
  name: recommendationservice
spec:
  selector:
    app: recommendationservice
  ports:
  - protocol: TCP
    port: 8080
    targetPort: 8080
  type: ClusterIP