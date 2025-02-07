package main

import (
	"fmt"
	"math/rand"
	"os"
)

type BasicError struct {
	Description string
}

type CloseError struct {
	BasicError
}

type ProcessError struct {
	BasicError
}

func (e BasicError) Error() string {
	return e.Description
}

type Resource struct {
	Id int
}

func (r Resource) Close() error {
	_, err := fmt.Printf("Closing %v\n", r)
	if err != nil {
		return CloseError{BasicError{"Close error: " + err.Error()}}
	}
	if rand.Intn(2) > 0 {
		return CloseError{BasicError{"Random close error"}}
	}
	return nil
}

func process(resource Resource) (int, error) {
	_, err := fmt.Printf("Created %v\n", resource)
	if err != nil {
		return 0, err
	}
	switch rand.Intn(3) {
	case 1:
		return 0, ProcessError{BasicError{"Random process error"}}
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
	result, err := process(resource)
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

func report(errs []error) {
	fmt.Println("Errors happened:")
	for _, err := range errs {
		fmt.Println("\t" + err.Error())
	}
}

func main() {
	result, errs := work()
	fmt.Printf("Result: %v\n", result)
	if len(errs) > 0 {
		report(errs)
		os.Exit(1)
	}
}
