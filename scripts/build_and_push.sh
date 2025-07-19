#!/bin/bash

set -e

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO_NAME="laravel-counter"
IMAGE_TAG="latest"
CLUSTER_NAME="laravel-counter-cluster"
SERVICE_NAME="laravel-counter-service"

echo "👉 Building Docker image for linux/amd64..."
DOCKER_BUILDKIT=0 docker build --platform linux/amd64 -t ${ECR_REPO_NAME}:${IMAGE_TAG} ./laravel-counter

echo "👉 Tagging image for ECR push..."
docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}

echo "👉 Logging into ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

echo "👉 Pushing image to ECR..."
docker push ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}

echo "👉 New ECS deployment started..."
aws ecs update-service \
  --cluster ${CLUSTER_NAME} \
  --service ${SERVICE_NAME} \
  --force-new-deployment \
  --region ${AWS_REGION}

aws ecs wait services-stable \
  --cluster ${CLUSTER_NAME} \
  --service ${SERVICE_NAME} \
  --region ${AWS_REGION}

echo "Deployment complete and service stable!"
