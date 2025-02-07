package main

import (
	"fmt"
	"math/rand"
	"os"
)

type CloseError struct{}

func (e *CloseError) Error() string {
	return "Close error"
}

type ProcessError struct{}

func (e *ProcessError) Error() string {
	return "Process error"
}

type Resource struct {
	Id int
}

func (resource *Resource) String() string {
	return fmt.Sprintf("{%d}", resource.Id)
}

func (resource *Resource) Close() error {
	_, err := fmt.Printf("Closing: %v\n", resource)
	if err != nil {
		return err
	}
	if rand.Intn(2) > 0 {
		return &CloseError{}
	}
	return nil
}

func (resource *Resource) process() (int, error) {
	_, err := fmt.Printf("Created: %v\n", resource)
	if err != nil {
		return 0, err
	}
	switch rand.Intn(3) {
	case 1:
		return 0, &ProcessError{}
	case 2:
		panic("Random panic")
	default:
		return resource.Id, nil
	}
}

func work() (result int, errs []error) {
	// Create guard
	var guard *Resource
	defer func() {
		if guard == nil {
			return
		}
		err := guard.Close()
		if err != nil {
			errs = append(errs, err)
		}
	}()

	// Create resource and immediately protect it with guard
	resource := Resource{42}
	guard = &resource

	// Process / use resource and generate result
	result, err := resource.process()
	if err != nil {
		errs = append(errs, err)
	}

	// Normal closing of resource with immediate un-protection
	err = resource.Close()
	guard = nil

	// Return results
	if err != nil {
		errs = append(errs, err)
	}
	return
}

func reportErrors(errs []error) {
	fmt.Println("Errors happened:")
	for _, err := range errs {
		fmt.Printf("\t%v\n", err)
	}
}

func main() {
	result, errs := work()
	fmt.Printf("Processing result: %v\n", result)
	if len(errs) > 0 {
		reportErrors(errs)
		os.Exit(1)
	}
}
