package config

import (
	"fmt"

	"github.com/knadh/koanf/parsers/yaml"
	"github.com/knadh/koanf/providers/file"
	"github.com/knadh/koanf/v2"
)

type GlobalConfig struct {
	Api       *ApiConf       `koanf:"api"`
	VoicePeak *VoicePeakConf `koanf:"voicepeak"`
}

type ApiConf struct {
	Host string `koanf:"host"`
	Port string `koanf:"port"`
}

type VoicePeakConf struct {
	BinPath   string `koanf:"bin_path"`
	WavFolder string `koanf:"wav_folder"`
}

func Load() (*GlobalConfig, error) {
	k := koanf.New(".")
	if err := k.Load(file.Provider("env.yaml"), yaml.Parser()); err != nil {
		return nil, fmt.Errorf("failed to load config file: %w", err)
	}

	conf := &GlobalConfig{}
	if err := k.Unmarshal("", conf); err != nil {
		return nil, fmt.Errorf("failed to unmarshal config: %w", err)
	}

	return conf, nil
}
