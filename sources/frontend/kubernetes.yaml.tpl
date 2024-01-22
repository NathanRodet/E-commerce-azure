apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels: 
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: gcr.io/GOOGLE_CLOUD_PROJECT/frontend:COMMIT_SHA
        env:
        - name: PORT
          value: "8080"
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        - name: SHIPPING_SERVICE_ADDR
          value: "shippingservice:50051"
        - name: CART_SERVICE_ADDR
          value: "cartservice:7070"
        - name: CURRENCY_SERVICE_ADDR
          value: "currencyservice:7000"
        - name: CHECKOUT_SERVICE_ADDR
          value: "checkoutservice:5050"
        - name: RECOMMENDATION_SERVICE_ADDR
          value: "recommendationservice:8080"
        - name: AD_SERVICE_ADDR
          value: "adservice:9555"
        ports:
        - containerPort: 8080
---
kind: Service
apiVersion: v1
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer