apiVersion: apps/v1
kind: Deployment
metadata:
  name: loadgenerator
  labels: 
    app: loadgenerator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: loadgenerator
  template:
    metadata:
      labels:
        app: loadgenerator
    spec:
      containers:
      - name: loadgenerator
        image: gcr.io/GOOGLE_CLOUD_PROJECT/loadgenerator:COMMIT_SHA
        env:
        - name: loadgenerator_ADDR
          value: "loadgenerator:80"
---
kind: Service
apiVersion: v1
metadata:
  name: loadgenerator
spec:
  selector:
    app: loadgenerator
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP