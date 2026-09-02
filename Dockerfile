# ---- Build stage ----
FROM golang:1.23-alpine AS builder

WORKDIR /src

COPY go.mod ./
COPY greeter.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /out/greeter greeter.go

# ---- Final stage ----
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /out/greeter /greeter

USER nonroot:nonroot

EXPOSE 8080

ENTRYPOINT ["/greeter"]
