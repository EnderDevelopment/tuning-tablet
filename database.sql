CREATE TABLE IF NOT EXISTS tuning_tablet_presets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    preset_name VARCHAR(50) NOT NULL,
    traction FLOAT NOT NULL,
    boost FLOAT NOT NULL,
    power FLOAT NOT NULL,
    exhaust_size VARCHAR(10) NOT NULL,
    backfire_effect BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tuning_tablet_presets (player_id, preset_name, traction, boost, power, exhaust_size, backfire_effect) VALUES
(1, 'eco', 0.8, 0.5, 0.7, 'medium', false),
(1, 'normal', 1.0, 1.0, 1.0, 'medium', false),
(1, 'sport', 1.2, 1.5, 1.3, 'medium', true),
(1, 'track', 1.5, 2.0, 1.5, 'large', true);