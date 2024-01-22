apiVersion: apps/v1
kind: Deployment
metadata:
  name: currencyservice
  labels: 
    app: currencyservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: currencyservice
  template:
    metadata:
      labels:
        app: currencyservice
    spec:
      containers:
      - name: currencyservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/currencyservice:COMMIT_SHA
        env:
        - name: PORT
          value: "7000"
        ports:
        - containerPort: 7000
---
kind: Service
apiVersion: v1
metadata:
  name: currencyservice
spec:
  selector:
    app: currencyservice
  ports:
  - protocol: TCP
    port: 7000
    targetPort: 7000
  type: ClusterIP