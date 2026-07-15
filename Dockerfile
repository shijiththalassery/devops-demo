name: Build and Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Deploy to EC2
        uses: appleboy/ssh-action@v1.0.3

        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}

          script: |
            cd ~/devops-demo

            git pull origin main

            docker build -t devops-web .

            docker stop devops-web || true

            docker rm devops-web || true

            docker run -d \
              --name devops-web \
              -p 80:80 \
              devops-web
              