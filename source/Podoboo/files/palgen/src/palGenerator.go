package main

import (
	"bufio"
	"errors"
	"fmt"
	_ "golang.org/x/image/bmp"
	"image"
	"image/color"
	_ "image/jpeg"
	_ "image/png"
	"io/ioutil"
	"os"
)

var backAreaColorOffset = image.Point{362, 59}

const (
	pixelsPerColor = 16
	colorsPerAxis  = 16
)

func main() {

	imgFilename, err := getImageFilename()
	if err != nil {
		fmt.Println(err.Error())
		pause()
		return
	}

	imgFile, err := os.Open(imgFilename)
	if err != nil {
		fmt.Println("Could not open the file. (If the file name has spaces, put it in \"quotes\".)")
		pause()
		return
	}

	img, _, err := image.Decode(imgFile)
	if err != nil {
		fmt.Println(err.Error())
		pause()
		return
	}

	startingPoint, err := findProbableStartingPoint(img)
	if err != nil {
		fmt.Println(err.Error())
		pause()
		return
	}

	paletteData, err := getPaletteDataFromImage(img, startingPoint)
	if err != nil {
		fmt.Println(err.Error())
		pause()
		return
	}

	palFilename := imgFilename + ".pal"
	_ = ioutil.WriteFile(palFilename, paletteData, 0666)

	fmt.Println("Generated palette file " + palFilename + ".")
	pause()

}

func pause() {

	fmt.Print("Press Enter to continue...")
	bufio.NewReader(os.Stdin).ReadBytes('\n')

}

func getImageFilename() (string, error) {

	var imgFilename string
	if len(os.Args) == 1 {
		input, err := getInput("Screenshot of Lunar Magic's palette editor:")
		if err != nil {
			return "", err
		}
		imgFilename = input
	} else {
		imgFilename = os.Args[1]
	}

	return imgFilename, nil

}

func getInput(prompt string) (string, error) {

	fmt.Print(prompt, " ")

	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	input := scanner.Text()

	return input, scanner.Err()

}

func findProbableStartingPoint(img image.Image) (image.Point, error) {

	bounds := img.Bounds()
	paletteSize := pixelsPerColor * colorsPerAxis

	for y := bounds.Min.Y; y <= bounds.Max.Y-paletteSize; y++ {
		for x := bounds.Min.X; x <= bounds.Max.X-paletteSize; x++ {

			if isProbableStartingPoint(img, image.Point{x, y}) {
				return image.Point{x, y}, nil
			}

		}
	}

	return image.Point{}, errors.New("Nothing in that image looks like a palette from Lunar Magic.")

}

func isProbableStartingPoint(img image.Image, candidatePoint image.Point) bool {

	for i := 0; i < colorsPerAxis; i++ {

		currPoint := candidatePoint.Add(image.Point{i * pixelsPerColor, i * pixelsPerColor})
		if !currPoint.In(img.Bounds()) {
			return false
		}
		if !isSingleColorDiagonal(img, currPoint) {
			return false
		}

	}
	return true

}

func isSingleColorDiagonal(img image.Image, startingPoint image.Point) bool {

	r, g, b, _ := img.At(startingPoint.X, startingPoint.Y).RGBA()

	for i := 1; i < pixelsPerColor; i++ {

		currPoint := startingPoint.Add(image.Point{i, i})
		if !currPoint.In(img.Bounds()) {
			return false
		}

		newR, newG, newB, _ := img.At(currPoint.X, currPoint.Y).RGBA()
		if r != newR || g != newG || b != newB {
			return false
		}

	}

	return true

}

func getPaletteDataFromImage(img image.Image, startingPoint image.Point) ([]byte, error) {

	data := make([]byte, 0, 768)

	backAreaColor, err := getBackAreaColor(img, startingPoint)
	hasBackAreaColor := (err == nil)

	for y := 0; y < colorsPerAxis; y++ {
		for x := 0; x < colorsPerAxis; x++ {

			currPoint := startingPoint.Add(image.Point{x * pixelsPerColor, y * pixelsPerColor})

			var r, g, b uint32
			if x == 0 && hasBackAreaColor {
				r, g, b, _ = backAreaColor.RGBA()
			} else {
				r, g, b, _ = img.At(currPoint.X, currPoint.Y).RGBA()
			}

			rB := byte(r & 0xFF)
			gB := byte(g & 0xFF)
			bB := byte(b & 0xFF)
			data = append(data, rB, gB, bB)

		}
	}

	return data, nil

}

func getBackAreaColor(img image.Image, startingPoint image.Point) (color.Color, error) {

	colorLocation := startingPoint.Add(backAreaColorOffset)

	if !colorLocation.In(img.Bounds()) {
		return nil, errors.New("Couldn't determine back area color.")
	}

	return img.At(colorLocation.X, colorLocation.Y), nil

}
