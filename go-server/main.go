package main

import (
	"net/http"
	"fmt"
	"github.com/gin-gonic/gin"
)

type Tile struct {
	X int `json:"x"`
	Y int `json:"y"`
}

type MapData struct {
	Data []Tile `json:"data"`
}

var currentMap MapData

func main() {
	r := gin.Default()

	// Reactからのアクセスを許可
	r.Use(func(c *gin.Context) {
    	c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
    	c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS")
    	c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")
    	if c.Request.Method == "OPTIONS" {
        	c.AbortWithStatus(204)
        	return
    	}
    	c.Next()
	})

	// マップ保存 
	r.POST("/api/save-map", func(c *gin.Context) {
		var json MapData
		if err := c.ShouldBindJSON(&json); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		
		currentMap = json 
		
		fmt.Printf("マップ更新: %d 個のタイルを受信\n", len(currentMap.Data))
		
		c.JSON(http.StatusOK, gin.H{
			"status":  "success",
			"message": "Map saved successfully!",
		})
	})

	// マップ取得 
	r.GET("/api/get-map", func(c *gin.Context) {
		if currentMap.Data == nil {
			currentMap.Data = []Tile{}
		}
		c.JSON(http.StatusOK, currentMap)
	})

	fmt.Println("Server running on http://localhost:8080")
	r.Run(":8080")
}