package main

import (
	"errors"
	"fmt"
	"io"
	"log"
	"math/rand"
)

func main() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds | log.LUTC | log.Lshortfile | log.Lmsgprefix)
	result, err := work()
	fmt.Printf("Processing result: %v\n", result)
	if err != nil {
		log.Fatal(err)
	}
}

type resource struct {
	id int
}

type closeError struct{}

type processError struct{}

func work() (result int, err error) {
	// Create guard for resource...
	var guard io.Closer
	// ... and prepare resource freeing in advance
	// to ensure it cannot be impacted by insufficient stack / heap or any other errors.
	// It is important for this operation to happen before resource is created / allocated.
	defer func() {
		if guard != nil {
			err = joinErrors(err, guard.Close())
		}
	}()

	// Create resource and immediately protect it with guard.
	// There should be no other operations b/w these two.
	r := resource{42}
	guard = &r

	// Process / use resource and generate result as usual.
	result, err = r.process()

	// Usual freeing of resource with immediate un-protection.
	// There should be no other operations b/w these two.
	closeErr := r.Close()
	guard = nil

	// Return results
	err = joinErrors(err, closeErr)
	return
}

func (r *resource) process() (int, error) {
	_, err := fmt.Printf("Created: %v\n", r)
	if err != nil {
		return 0, err
	}
	switch rand.Intn(3) {
	case 1:
		return 0, &processError{}
	case 2:
		panic("Random panic")
	default:
		return r.id, nil
	}
}

func (r *resource) Close() error {
	_, err := fmt.Printf("Closing: %v\n", r)
	if err != nil {
		return err
	}
	if rand.Intn(2) > 0 {
		return &closeError{}
	}
	return nil
}

func joinErrors(e1, e2 error) error {
	if e2 == nil {
		return e1
	}
	if e1 == nil {
		return e2
	}
	return errors.Join(e1, e2)
}

func (r *resource) String() string {
	return fmt.Sprintf("{%d}", r.id)
}

func (e *closeError) Error() string {
	return "Close error"
}

func (e *processError) Error() string {
	return "Process error"
}
