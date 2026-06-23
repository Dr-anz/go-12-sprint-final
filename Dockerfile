FROM golang:1.25-alpine AS builder

WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /app  # изменено с /root на /app — более стандартно
COPY --from=builder /app/main .
COPY --from=builder /app/tracker.db .
EXPOSE 8080
CMD ["./main"]
