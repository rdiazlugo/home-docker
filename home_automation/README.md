# Home Automation Server - Raspberry Pi

This Docker Compose setup provides a complete home automation stack running on a Raspberry Pi, featuring Home Assistant, ESPHome, and Zigbee2MQTT for comprehensive smart home management.

## Services Overview

### 🏠 Home Assistant
**Container**: `homeassistant`
**Image**: `ghcr.io/home-assistant/home-assistant:stable`
**Access**: Host network mode (typically port 8123)

Home Assistant is the central hub for your smart home automation. It provides:
- Web-based dashboard for device control and monitoring
- Automation and scene management
- Integration with hundreds of IoT devices and services
- Mobile app support for remote access

**Configuration**:
- **Volumes**:
  - `./ha_config:/config` - Persistent storage for Home Assistant configuration
  - `/etc/localtime:/etc/localtime:ro` - System timezone synchronization
  - `/run/dbus:/run/dbus:ro` - D-Bus access for system integration
- **Network**: Host mode for direct hardware access and service discovery
- **Privileges**: Runs privileged for hardware access (USB devices, GPIO, etc.)

### 🔌 ESPHome
**Container**: `esphome`
**Image**: `ghcr.io/esphome/esphome:stable`
**Access**: Host network mode (typically port 6052)

ESPHome is a system for controlling ESP8266/ESP32 microcontrollers with simple YAML configuration files. It enables:
- Custom firmware creation for ESP devices
- Over-the-air (OTA) updates
- Direct integration with Home Assistant
- Web-based device management interface

**Configuration**:
- **Volumes**:
  - `./esphome_config:/config` - ESPHome device configurations and compiled firmware
  - `/etc/localtime:/etc/localtime:ro` - System timezone synchronization
- **Environment Variables**:
  - `ESPHOME_USERNAME` - Web interface authentication username
  - `ESPHOME_PASSWORD` - Web interface authentication password
- **Network**: Host mode for device discovery and flashing
- **Privileges**: Privileged access for USB device communication

### 📡 Zigbee2MQTT
**Container**: `zigbee2mqtt`
**Image**: `ghcr.io/koenkk/zigbee2mqtt`
**Access**: Port 8081 (mapped from container port 8080)

Zigbee2MQTT acts as a bridge between Zigbee devices and MQTT, allowing you to control Zigbee devices without proprietary hubs. Features include:
- Support for 2000+ Zigbee devices
- Web-based management interface
- Device pairing and network visualization
- Direct MQTT integration for Home Assistant

**Configuration**:
- **Volumes**:
  - `./zigbee2mqtt_data:/app/data` - Persistent storage for device database and network configuration
  - `/run/udev:/run/udev:ro` - USB device detection
  - `/etc/localtime:/etc/localtime:ro` - System timezone synchronization
- **Ports**: `8081:8080` - Web interface access
- **Hardware**:
  - **Zigbee Coordinator**: Sonoff Zigbee 3.0 USB Dongle Plus
    - [Firmware Install](https://smarthomescene.com/guides/how-to-enable-thread-and-matter-support-on-sonoff-zbdongle-e/)
    - [Flasher](https://darkxst.github.io/silabs-firmware-builder/)
    - [Fix installation stuck](https://github.com/darkxst/silabs-firmware-builder/issues/179)
  - **Device Path**: `/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_*`
- **Environment Variables**:
  - `TZ: Europe/Berlin` - Timezone configuration
  - `ZIGBEE2MQTT_CONFIG_homeassistant_enabled: true` - Enable Home Assistant integration
  - `ZIGBEE2MQTT_CONFIG_MQTT_BASE_TOPIC: zigbee2mqtt` - MQTT topic prefix
  - `ZIGBEE2MQTT_CONFIG_MQTT_SERVER` - MQTT broker address
  - `ZIGBEE2MQTT_CONFIG_MQTT_USER` - MQTT authentication username
  - `ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD` - MQTT authentication password
  - `ZIGBEE2MQTT_CONFIG_SERIAL_PORT: ember` - Serial interface configuration

## Required Environment Variables

Create a `.env` file in the same directory with the following variables:

```env
# ESPHome Authentication
ESPHOME_USERNAME=your_esphome_username
ESPHOME_PASSWORD=your_esphome_password

# Zigbee2MQTT MQTT Configuration
ZIGBEE2MQTT_CONFIG_MQTT_SERVER=mqtt://your-mqtt-broker:1883
ZIGBEE2MQTT_CONFIG_MQTT_USER=your_mqtt_username
ZIGBEE2MQTT_CONFIG_MQTT_PASSWORD=your_mqtt_password
```

## Hardware Requirements

### Raspberry Pi Setup
- **Recommended**: Raspberry Pi 4 with 4GB+ RAM
- **Storage**: 32GB+ microSD card (Class 10 or better)
- **USB Ports**: Available for Zigbee coordinator

### Zigbee Coordinator
- **Supported Device**: Sonoff Zigbee 3.0 USB Dongle Plus (TI CC2652P chip)
- **Alternative Options**: ConBee II, HUSBZB-1, or other Zigbee 3.0 coordinators

## Directory Structure

```
server-raspberry-pi/
├── docker-compose.yaml
├── .env
├── ha_config/              # Home Assistant configuration
├── esphome_config/         # ESPHome device configurations
└── zigbee2mqtt_data/       # Zigbee2MQTT database and settings
```

## Getting Started

1. **Prepare Environment**:
   ```bash
   # Create required directories
   mkdir -p ha_config esphome_config zigbee2mqtt_data

   # Set proper permissions
   chmod 755 ha_config esphome_config zigbee2mqtt_data
   ```

2. **Configure Environment Variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your specific configuration
   ```

3. **Identify Zigbee Coordinator**:
   ```bash
   # Find your Zigbee USB device
   ls -la /dev/serial/by-id/
   # Update the device path in docker-compose.yaml
   ```

4. **Deploy Services**:
   ```bash
   docker-compose up -d
   ```

5. **Access Services**:
   - **Home Assistant**: `http://raspberry-pi-ip:8123`
   - **ESPHome**: `http://raspberry-pi-ip:6052`
   - **Zigbee2MQTT**: `http://raspberry-pi-ip:8081`

## Service Integration

### Home Assistant ↔ Zigbee2MQTT
- Zigbee devices automatically appear in Home Assistant via MQTT discovery
- Device states and controls are synchronized in real-time
- Network topology and device management through Zigbee2MQTT web interface

### Home Assistant ↔ ESPHome
- ESPHome devices auto-discovered by Home Assistant
- Native API integration for fast, reliable communication
- OTA updates managed through ESPHome dashboard

## Troubleshooting

### Common Issues

1. **Zigbee Coordinator Not Found**:
   ```bash
   # Check USB devices
   lsusb
   ls -la /dev/tty*
   # Verify device permissions and docker group membership
   ```

2. **Services Not Starting**:
   ```bash
   # Check logs
   docker-compose logs -f [service-name]
   # Verify environment variables
   docker-compose config
   ```

3. **Network Connectivity**:
   - Ensure host network mode is properly configured
   - Check firewall settings for required ports
   - Verify MQTT broker connectivity

### Useful Commands

```bash
# View service logs
docker-compose logs -f homeassistant
docker-compose logs -f zigbee2mqtt
docker-compose logs -f esphome

# Restart specific service
docker-compose restart homeassistant

# Update services
docker-compose pull
docker-compose up -d

# Backup configurations
tar -czf backup-$(date +%Y%m%d).tar.gz ha_config esphome_config zigbee2mqtt_data
```

## Security Considerations

- Change default passwords for all services
- Use strong MQTT authentication
- Consider running behind a reverse proxy with SSL
- Regularly update container images
- Backup configurations frequently
- Limit network access to trusted devices only

## Performance Optimization

- Use high-quality microSD card (Application Class A2)
- Consider USB 3.0 storage for better I/O performance
- Monitor resource usage with `docker stats`
- Adjust restart policies based on stability requirements
