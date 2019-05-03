#!/usr/bin/env sh

kubectl apply -f src/main/k8s/ \
  --certificate-authority $CA \
  --client-certificate $CERT \
  --client-key $KEY