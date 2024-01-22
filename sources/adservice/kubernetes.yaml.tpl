apiVersion: apps/v1
kind: Deployment
metadata:
  name: adservice
  labels: 
    app: adservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: adservice
  template:
    metadata:
      labels:
        app: adservice
    spec:
      containers:
      - name: adservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/adservice:COMMIT_SHA
        ports:
        - containerPort: 9555
---
kind: Service
apiVersion: v1
metadata:
  name: adservice
spec:
  selector:
    app: adservice
  ports:
  - protocol: TCP
    port: 9555
    targetPort: 9555
  type: ClusterIP