package main

import (
	"errors"
	"fmt"
	"io"
	"log"
	"math/rand"
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

func work() (result int, err error) {
	// Create guard
	var guard io.Closer
	defer func() {
		if guard == nil {
			return
		}
		closeErr := guard.Close()
		if closeErr != nil {
			err = errors.Join(err, closeErr)
		}
	}()

	// Create resource and immediately protect it with guard
	resource := Resource{42}
	guard = &resource

	// Process / use resource and generate result
	result, err = resource.process()

	// Normal closing of resource with immediate un-protection
	closeErr := resource.Close()
	guard = nil

	// Return results
	if closeErr != nil {
		err = errors.Join(err, closeErr)
	}
	return
}

func main() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds | log.LUTC | log.Lshortfile | log.Lmsgprefix)
	result, err := work()
	fmt.Printf("Processing result: %v\n", result)
	if err != nil {
		log.Fatal(err)
	}
}
