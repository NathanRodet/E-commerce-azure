apiVersion: apps/v1
kind: Deployment
metadata:
  name: shippingservice
  labels: 
    app: shippingservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: shippingservice
  template:
    metadata:
      labels:
        app: shippingservice
    spec:
      containers:
      - name: shippingservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/shippingservice:COMMIT_SHA
        env:
        - name: PORT
          value: "50051"
        ports:
        - containerPort: 50051
---
kind: Service
apiVersion: v1
metadata:
  name: shippingservice
spec:
  selector:
    app: shippingservice
  ports:
  - protocol: TCP
    port: 50051
    targetPort: 50051
  type: ClusterIP