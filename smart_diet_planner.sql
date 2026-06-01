-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 02 juin 2026 à 01:01
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `smart_diet_planner`
--

-- --------------------------------------------------------

--
-- Structure de la table `allergies`
--

CREATE TABLE `allergies` (
  `id` int(11) NOT NULL,
  `allergy_name` varchar(50) NOT NULL,
  `foods_to_avoid` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `allergies`
--

INSERT INTO `allergies` (`id`, `allergy_name`, `foods_to_avoid`) VALUES
(1, 'gluten', 'Wheat, barley, rye, bread, pasta, baked goods'),
(2, 'lactose', 'Milk, cream, soft cheeses, ice cream, whey'),
(3, 'dairy', 'All milk products including cheese, yogurt, butter'),
(4, 'nuts', 'Tree nuts (almonds, walnuts, cashews), peanuts'),
(5, 'seafood', 'Fish, shellfish, shrimp, crab, lobster'),
(6, 'soy', 'Soybeans, tofu, soy sauce, edamame, tempeh'),
(7, 'eggs', 'Eggs, mayonnaise, baked goods containing eggs'),
(8, 'sesame', 'Sesame seeds, tahini, sesame oil');

-- --------------------------------------------------------

--
-- Structure de la table `health_conditions`
--

CREATE TABLE `health_conditions` (
  `id` int(11) NOT NULL,
  `condition_name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `diet_recommendation` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `health_conditions`
--

INSERT INTO `health_conditions` (`id`, `condition_name`, `description`, `diet_recommendation`) VALUES
(1, 'diabetes', 'Blood sugar management condition', 'Focus on low glycemic index foods, high fiber, and controlled carbohydrate portions.'),
(2, 'low_iron', 'Iron deficiency anemia', 'Increase iron-rich foods like spinach, lentils, and lean meats. Pair with vitamin C for better absorption.'),
(3, 'high_cholesterol', 'Elevated blood cholesterol', 'Reduce saturated fats. Increase soluble fiber from oats and beans. Include healthy fats from avocado and nuts.'),
(4, 'hypertension', 'High blood pressure', 'Reduce sodium intake. Increase potassium-rich foods. Focus on whole foods over processed options.');

-- --------------------------------------------------------

--
-- Structure de la table `meals`
--

CREATE TABLE `meals` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `meal_type` enum('breakfast','lunch','dinner') NOT NULL,
  `diet_type` enum('normal','vegetarian','vegan') NOT NULL,
  `calories` int(11) NOT NULL,
  `protein` int(11) NOT NULL,
  `carbs` int(11) NOT NULL,
  `fat` int(11) NOT NULL,
  `fiber` int(11) DEFAULT 0,
  `reason` text DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `meals`
--

INSERT INTO `meals` (`id`, `name`, `meal_type`, `diet_type`, `calories`, `protein`, `carbs`, `fat`, `fiber`, `reason`, `image_url`) VALUES
(1, 'Oatmeal with berries', 'breakfast', 'normal', 300, 10, 54, 6, 8, 'High fiber helps regulate blood sugar and keeps you full longer.', NULL),
(2, 'Scrambled eggs with spinach', 'breakfast', 'normal', 280, 18, 3, 22, 1, 'Iron-rich spinach combats fatigue. High protein for muscle maintenance.', NULL),
(3, 'Greek yogurt with honey and nuts', 'breakfast', 'normal', 250, 20, 22, 12, 1, 'Probiotics support gut health. Protein keeps you satisfied.', NULL),
(4, 'Whole grain toast with avocado', 'breakfast', 'normal', 290, 8, 28, 18, 7, 'Healthy fats for heart health and sustained energy.', NULL),
(5, 'Smoothie bowl', 'breakfast', 'normal', 320, 12, 48, 10, 6, 'Packed with vitamins and antioxidants.', NULL),
(6, 'Greek yogurt with honey', 'breakfast', 'vegetarian', 250, 20, 22, 12, 1, 'Probiotics support gut health.', NULL),
(7, 'Avocado toast with feta', 'breakfast', 'vegetarian', 310, 10, 26, 20, 7, 'Healthy fats and calcium for strong bones.', NULL),
(8, 'Vegetable omelette', 'breakfast', 'vegetarian', 270, 16, 5, 20, 2, 'Packed with vitamins and protein.', NULL),
(9, 'Cottage cheese with fruit', 'breakfast', 'vegetarian', 220, 24, 18, 8, 2, 'High casein protein for slow release.', NULL),
(10, 'Whole grain pancakes', 'breakfast', 'vegetarian', 350, 11, 52, 12, 4, 'Slow-release energy for morning workouts.', NULL),
(11, 'Oatmeal with fruits', 'breakfast', 'vegan', 300, 9, 56, 6, 8, 'Plant-based fiber and antioxidants.', NULL),
(12, 'Smoothie bowl', 'breakfast', 'vegan', 320, 12, 48, 10, 6, 'Packed with vitamins and antioxidants.', NULL),
(13, 'Chia pudding with almond milk', 'breakfast', 'vegan', 270, 9, 28, 15, 10, 'Omega-3s reduce inflammation. High fiber.', NULL),
(14, 'Tofu scramble', 'breakfast', 'vegan', 260, 20, 8, 16, 3, 'Plant-based complete protein.', NULL),
(15, 'Peanut butter banana toast', 'breakfast', 'vegan', 340, 12, 42, 16, 6, 'Energy-dense for active mornings.', NULL),
(16, 'Grilled chicken salad', 'lunch', 'normal', 400, 35, 12, 22, 4, 'Lean protein for muscle maintenance. Fresh vegetables provide vitamins.', NULL),
(17, 'Tuna sandwich with whole grain bread', 'lunch', 'normal', 420, 30, 38, 16, 5, 'Omega-3 fatty acids for heart health.', NULL),
(18, 'Chicken and vegetable wrap', 'lunch', 'normal', 380, 28, 34, 15, 4, 'Balanced macros with fiber from vegetables.', NULL),
(19, 'Grilled chicken with rice', 'lunch', 'normal', 420, 35, 45, 12, 3, 'Lean protein with complex carbs for energy.', NULL),
(20, 'Beef and quinoa bowl', 'lunch', 'normal', 450, 32, 40, 18, 5, 'Iron-rich beef with complete protein quinoa.', NULL),
(21, 'Lentil soup', 'lunch', 'vegetarian', 320, 18, 48, 6, 12, 'High in iron and fiber. Supports healthy digestion.', NULL),
(22, 'Veggie wrap with hummus', 'lunch', 'vegetarian', 360, 14, 40, 18, 8, 'Plant-based protein with heart-healthy fats.', NULL),
(23, 'Spinach and feta quiche', 'lunch', 'vegetarian', 380, 16, 28, 24, 3, 'Iron and calcium boost for energy.', NULL),
(24, 'Caprese sandwich', 'lunch', 'vegetarian', 340, 14, 36, 18, 3, 'Fresh mozzarella provides calcium and protein.', NULL),
(25, 'Spinach omelette', 'lunch', 'vegetarian', 300, 20, 5, 22, 2, 'Quick protein-rich lunch with iron from spinach.', NULL),
(26, 'Lentil salad', 'lunch', 'vegan', 310, 17, 44, 8, 12, 'Complete plant protein with iron.', NULL),
(27, 'Vegetable stir-fry with tofu', 'lunch', 'vegan', 340, 20, 28, 16, 6, 'Low in saturated fat. High in plant protein.', NULL),
(28, 'Quinoa bowl with roasted vegetables', 'lunch', 'vegan', 380, 14, 48, 14, 8, 'Complete protein with all essential amino acids.', NULL),
(29, 'Bean and rice burrito bowl', 'lunch', 'vegan', 440, 20, 68, 10, 12, 'Fiber and complex carbs for sustained energy.', NULL),
(30, 'Chickpea and avocado wrap', 'lunch', 'vegan', 350, 14, 42, 16, 10, 'Healthy fats and plant protein combination.', NULL),
(31, 'Salmon with steamed broccoli', 'dinner', 'normal', 450, 35, 12, 28, 5, 'Omega-3 fatty acids reduce inflammation. High quality protein.', NULL),
(32, 'Grilled chicken with quinoa', 'dinner', 'normal', 420, 38, 35, 14, 5, 'Lean protein with complex carbs for recovery.', NULL),
(33, 'Turkey meatballs with zucchini noodles', 'dinner', 'normal', 430, 32, 18, 24, 4, 'Low carb option with lean protein.', NULL),
(34, 'Shrimp and asparagus stir-fry', 'dinner', 'normal', 400, 30, 14, 22, 3, 'Low calorie, high protein seafood option.', NULL),
(35, 'Fish with vegetables', 'dinner', 'normal', 380, 32, 15, 20, 4, 'Light dinner with lean protein and fiber.', NULL),
(36, 'Pasta with tomato sauce and cheese', 'dinner', 'vegetarian', 410, 16, 52, 16, 4, 'Comfort food with calcium from cheese.', NULL),
(37, 'Vegetable soup with crusty bread', 'dinner', 'vegetarian', 340, 12, 48, 12, 8, 'Warming and nutrient-dense.', NULL),
(38, 'Eggplant parmesan', 'dinner', 'vegetarian', 380, 18, 36, 20, 6, 'Italian classic with fiber and protein.', NULL),
(39, 'Mushroom risotto', 'dinner', 'vegetarian', 420, 12, 56, 18, 3, 'Creamy comfort food with B vitamins.', NULL),
(40, 'Spinach and ricotta stuffed shells', 'dinner', 'vegetarian', 390, 20, 42, 18, 4, 'Calcium and iron rich dinner.', NULL),
(41, 'Chickpea curry', 'dinner', 'vegetarian', 370, 15, 48, 12, 8, 'Fiber-rich plant protein for heart health.', NULL),
(42, 'Chickpea curry with rice', 'dinner', 'vegan', 370, 15, 52, 10, 8, 'Fiber helps manage cholesterol and blood sugar.', NULL),
(43, 'Grilled tofu with quinoa', 'dinner', 'vegan', 390, 22, 38, 16, 6, 'Complete plant-based protein.', NULL),
(44, 'Vegetable lasagna', 'dinner', 'vegan', 410, 18, 48, 16, 8, 'Low-fat comfort food with layers of vegetables.', NULL),
(45, 'Bean chili', 'dinner', 'vegan', 380, 20, 52, 10, 14, 'High fiber and protein from beans.', NULL),
(46, 'Stuffed bell peppers with rice', 'dinner', 'vegan', 350, 12, 48, 12, 8, 'Colorful and nutrient-dense dinner.', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `created_at`) VALUES
(1, 'admin', 'admin123', 'Administrator', '2026-04-24 11:06:29'),
(5, 'bouassidachayma@gmail.com', 'chayma2004', 'chayma bouassida', '2026-06-01 19:44:29');

-- --------------------------------------------------------

--
-- Structure de la table `user_plans`
--

CREATE TABLE `user_plans` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `plan_date` date NOT NULL,
  `meal_type` enum('breakfast','lunch','dinner') NOT NULL,
  `meal_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `user_plans`
--

INSERT INTO `user_plans` (`id`, `user_id`, `plan_date`, `meal_type`, `meal_id`, `created_at`) VALUES
(85, 5, '2026-06-01', 'breakfast', 5, '2026-06-01 19:45:07'),
(86, 5, '2026-06-01', 'lunch', 20, '2026-06-01 19:45:07'),
(87, 5, '2026-06-01', 'dinner', 35, '2026-06-01 19:45:07'),
(88, 5, '2026-06-01', 'breakfast', 5, '2026-06-01 19:45:07'),
(89, 5, '2026-06-01', 'lunch', 16, '2026-06-01 19:45:07'),
(90, 5, '2026-06-01', 'dinner', 31, '2026-06-01 19:45:07'),
(91, 5, '2026-06-01', 'breakfast', 2, '2026-06-01 19:45:07'),
(92, 5, '2026-06-01', 'lunch', 17, '2026-06-01 19:45:07'),
(93, 5, '2026-06-01', 'dinner', 31, '2026-06-01 19:45:07'),
(94, 5, '2026-06-01', 'breakfast', 5, '2026-06-01 19:45:07'),
(95, 5, '2026-06-01', 'lunch', 20, '2026-06-01 19:45:07'),
(96, 5, '2026-06-01', 'dinner', 35, '2026-06-01 19:45:07'),
(97, 5, '2026-06-01', 'breakfast', 4, '2026-06-01 19:45:07'),
(98, 5, '2026-06-01', 'lunch', 17, '2026-06-01 19:45:07'),
(99, 5, '2026-06-01', 'dinner', 33, '2026-06-01 19:45:07'),
(100, 5, '2026-06-01', 'breakfast', 5, '2026-06-01 19:45:07'),
(101, 5, '2026-06-01', 'lunch', 17, '2026-06-01 19:45:07'),
(102, 5, '2026-06-01', 'dinner', 31, '2026-06-01 19:45:07'),
(103, 5, '2026-06-01', 'breakfast', 4, '2026-06-01 19:45:07'),
(104, 5, '2026-06-01', 'lunch', 16, '2026-06-01 19:45:07'),
(105, 5, '2026-06-01', 'dinner', 33, '2026-06-01 19:45:07');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `allergies`
--
ALTER TABLE `allergies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `allergy_name` (`allergy_name`);

--
-- Index pour la table `health_conditions`
--
ALTER TABLE `health_conditions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `condition_name` (`condition_name`);

--
-- Index pour la table `meals`
--
ALTER TABLE `meals`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Index pour la table `user_plans`
--
ALTER TABLE `user_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `meal_id` (`meal_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `allergies`
--
ALTER TABLE `allergies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `health_conditions`
--
ALTER TABLE `health_conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `meals`
--
ALTER TABLE `meals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `user_plans`
--
ALTER TABLE `user_plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `user_plans`
--
ALTER TABLE `user_plans`
  ADD CONSTRAINT `user_plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_plans_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meals` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
