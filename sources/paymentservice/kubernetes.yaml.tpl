apiVersion: apps/v1
kind: Deployment
metadata:
  name: paymentservice
  labels: 
    app: paymentservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: paymentservice
  template:
    metadata:
      labels:
        app: paymentservice
    spec:
      containers:
      - name: paymentservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/paymentservice:COMMIT_SHA
        env:
        - name: PORT
          value: "50051"
        ports:
        - containerPort: 50051
---
kind: Service
apiVersion: v1
metadata:
  name: paymentservice
spec:
  selector:
    app: paymentservice
  ports:
  - protocol: TCP
    port: 50052
    targetPort: 50051
  type: ClusterIP