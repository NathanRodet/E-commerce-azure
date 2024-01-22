apiVersion: apps/v1
kind: Deployment
metadata:
  name: emailservice
  labels: 
    app: emailservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: emailservice
  template:
    metadata:
      labels:
        app: emailservice
    spec:
      containers:
      - name: emailservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/emailservice:COMMIT_SHA
        env:
        - name: PORT
          value: "8080"
        ports:
        - containerPort: 8080
---
kind: Service
apiVersion: v1
metadata:
  name: emailservice
spec:
  selector:
    app: emailservice
  ports:
  - protocol: TCP
    port: 5000
    targetPort: 8080
  type: ClusterIP