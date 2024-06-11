---
author: 'Pedro Barreiro'
title: 'Builder'
date: 2024-06-11
draft: false
tags: ["golang", "go", "Design patterns", "builder", "creational pattern"]
categories: ["Golang", "Design patterns"]
series: ["Design Patterns"]
---

# Understanding the Builder Pattern in Go

The Builder pattern is a design pattern that provides a flexible solution to object creation problems. It is used when the construction process of an object is complex. In Go, we can implement the Builder pattern by creating a separate Builder type that is responsible for incrementally building the object.

## Implementing a simple Builder in Go

Let's start with a simple example where we use a SimpleBuilder struct to construct a SimpleProduct object.

```go
type SimpleProduct struct {
	name  string
	value int
}

type SimpleBuilder struct {
	product SimpleProduct
}

func NewSimpleBuilder() *SimpleBuilder {
	return &SimpleBuilder{
		product: SimpleProduct{},
	}
}

func (b *SimpleBuilder) SetName(name string) *SimpleBuilder {
	b.product.name = name
	return b
}

func (b *SimpleBuilder) SetValue(value int) *SimpleBuilder {
	b.product.value = value
	return b
}

func (b *SimpleBuilder) Build() SimpleProduct {
	return b.product
}
```


In this example, `NewSimpleBuilder` is a factory function that returns a new instance of `SimpleBuilder`. The `SetName` and `SetValue` methods are used to set the `name` and `value` of the `SimpleProduct`, respectively. The `Build` method returns the final `SimpleProduct` object.

Here is an example of how to use the `SimpleBuilder` to create a `SimpleProduct`:

```go
product := builder.NewSimpleBuilder().
    SetName("Product").
    SetValue(100).
    Build()
```

## Advanced Builder

In a more complex scenario, we want to create two types of products: a default product and a custom product. We can achieve this by providing an input of `builderType` to the builder. The `DefaultBuilder` initializes the product with predefined values, while the `CustomBuilder` initializes the product with empty fields.

```go
type Product struct {
	name  string
	value int
}

type Builder interface {
	SetName(name string) Builder
	SetValue(value int) Builder
	Build() Product
}

type DefaultBuilder struct {
	product Product
}

type CustomBuilder struct {
	product Product
}

type BuilderType int

const (
	Default BuilderType = iota
	Custom
)

func NewBuilder(builderType BuilderType) Builder {
	switch builderType {
	case Default:
		return &DefaultBuilder{
			product: Product{
				name:  "Default",
				value: 0,
			},
		}
	case Custom:
		return &CustomBuilder{
			product: Product{},
		}
	default:
		return nil
	}
}

func (b *DefaultBuilder) SetName(name string) Builder {
	b.product.name = name
	return b
}

func (b *DefaultBuilder) SetValue(value int) Builder {
	b.product.value = value
	return b
}

func (b *DefaultBuilder) Build() Product {
	return b.product
}

func (b *CustomBuilder) SetName(name string) Builder {
	b.product.name = name
	return b
}

func (b *CustomBuilder) SetValue(value int) Builder {
	b.product.value = value
	return b
}

func (b *CustomBuilder) Build() Product {
	return b.product
}
```


In this example, `DefaultBuilder` and `CustomBuilder` are structs that implement the `Builder` interface. The `NewBuilder` function is a factory function that returns a new instance of a builder based on the `BuilderType`. The `SetName` and `SetValue` methods are used to set the `name` and `value` of the `Product`, respectively. The `Build` method returns the final `Product` object.

Here is an example of how to use the `Builder` to create a `Product`:

```go
product := builder.NewBuilder(builder.Custom).
    SetName("Product").
    SetValue(100).
    Build()
```

The Builder pattern is a great way to handle complex object creation in a readable and maintainable way. It separates the construction of an object from its representation, allowing the same construction process to create different representations.