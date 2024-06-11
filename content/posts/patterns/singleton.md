---
author: 'Pedro Barreiro'
title: 'Singleton'
date: 2024-06-07
draft: false
tags: ["golang", "go", "Design patterns", "singleton", "creational pattern"]
categories: ["Golang", "Design patterns"]
series: ["Design Patterns"]
---

#Singleton

The Singleton pattern is a design principle that restricts the instantiation of a type to one single instance. This is particularly useful in scenarios where a single point of control or access is required across the entire application, such as in configuration management or logging.

## Implementing a Singleton in Go

In Go, you can implement a Singleton by using a combination of a private struct and a public constructor function. Here's a simple example:

```go
type Singleton struct {
// Properties of the singleton
}

var (
    instance Singleton
    once sync.Once
)

func GetInstance() Singleton {
    once.Do(func() {
        instance = &Singleton{}
    })
    return instance
}
```

The `GetInstance` function is responsible for returning the single instance of the `Singleton` type. The `sync.Once` ensures that the instance is created only once, even when called from multiple goroutines.

## Testing the Singleton Pattern

To ensure that the Singleton pattern is correctly implemented, especially in concurrent environments, you should write tests.

### Testing Sequential Access

You can write a test to ensure that multiple calls to the `GetInstance` function return the same instance:

```go
func TestSingleton(t testing.T) {
    instance1 := GetInstance()
    instance2 := GetInstance()

    if instance1 != instance2 {
        t.Errorf("Expected instance1 and instance2 to be the same.")
    }
}
```

### Testing Concurrent Access

It's also important to test that the Singleton instance is properly handled when accessed concurrently:

```go
func TestSingletonConcurrent(t testing.T) {
    var wg sync.WaitGroup
    const numGoroutines = 100

    instances := make([]Singleton, numGoroutines)

    for i := 0; i < numGoroutines; i++ {
        wg.Add(1)
        go func(index int) {
            defer wg.Done()
            instances[index] = GetInstance()
        }(i)
    }

    wg.Wait()

    for i := 1; i < numGoroutines; i++ {
        if instances[i] != instances[0] {
            t.Errorf("Expected all instances to be the same.")
        }
    }
}
```

This test ensures that even when multiple goroutines try to get the Singleton instance, they all receive the same instance.

## Conclusion

The Singleton pattern is a useful tool for ensuring that only one instance of a type is created within an application. It's particularly beneficial for managing shared resources like configuration settings. However, it's important to use this pattern judiciously to avoid introducing global state that can make your application harder to test and maintain. Proper testing is crucial to ensure that the Singleton behaves as expected under both sequential and concurrent access.