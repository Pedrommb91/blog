---
author: 'Pedro Barreiro'
title: 'Builder'
date: 2024-06-11
draft: false
tags: ["golang", "go", "Design patterns", "builder", "creational pattern"]
categories: ["Golang", "Design patterns"]
series: ["Design Patterns"]
---

# Builder Pattern in Go

The *Builder* pattern aims to improve readability and simplify complex structure initialization providing a set of functions to populate all the required fields, and then return the product as a result. It allows for a simple approach only creating the builder and setting all inputs to build the product or creating several builders with default values.

## Simple approach

The base concept of the *Builder* pattern is to create and populate a struct with readability in mind, so that would be great if we could populate a struct with dozens of fields with nested functions and then return the expected result, this is exactly that this pattern does. So with the ideal scenario set, we want to implement the code so we can write the following code:

```go
product := builder.NewSimpleBuilder().
    SetName("Product").
    SetValue(100).
    Build()
```

To achieve this goal we need to implement a *Builder* of a `SimpleProduct` with a `name` and `value` fields. The builder implements functions to populate the fields and one function to return the final result. Check the following code as an abstract example:

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

## Advanced Builder

For those who need to create a lot of different complex structs of the same type and have a chunk of it equal between them, this approach allows to develop builders of the same type, enabling them to set diferent default values for each builder, simplifying the work of building. 

Extending the last example, now we want to create a builder with default values so we don't need to specify when building the struct as follows:

```go
product := builder.NewBuilder(builder.Default).
    Build()
```

Now we have a builder type as input to create the *Builder* so it retrieves the one we expect with the values already defined and, as the values are already defined we don't need to call the set functions. The following code represents an abstract example of how to implement the code that satisfies the upper code:

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

The *Builder* pattern is easy to implement and has a huge benefit for the readers, certantly for simple structs it could be an overhead to use, but for complex ones is a piece of mind.  