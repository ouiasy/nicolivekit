package main

import (
	"fmt"
	"log"

	"github.com/knadh/koanf/parsers/yaml"
	"github.com/knadh/koanf/providers/file"
	"github.com/knadh/koanf/v2"
)

func main() {
	k := koanf.New(".")
	if err := k.Load(file.Provider("test.yaml"), yaml.Parser()); err != nil {
		log.Fatal("Error loading yaml file")
	}

	fmt.Println(k.String("app.id"))
	fmt.Println(k.String("db.port"))

	// 構造体の変数を定義
	var cfg Config

	// Unmarshal で代入！
	// 第1引数の "" は「ルートからすべて読み込む」という意味です。
	// "app" と指定すれば app配下だけを読み込むことも可能です。
	if err := k.Unmarshal("", &cfg); err != nil {
		log.Fatalf("error unmarshaling config: %v", err)
	}

	// 結果の確認
	fmt.Printf("Full Config: %+v\n", cfg)
	fmt.Printf("App ID: %d\n", cfg.App.Id)
	fmt.Printf("DB Port: %s\n", cfg.Db.Port)

}

type Config struct {
	App *AppConfig `koanf:"app"`
	Db  *DBConfig  `koanf:"db"`
}

type AppConfig struct {
	Id int `koanf:"id"`
}

type DBConfig struct {
	Port string `koanf:"port"`
}
