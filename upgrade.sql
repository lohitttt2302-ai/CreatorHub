USE creator_hub;

ALTER TABLE Students
  ADD COLUMN IF NOT EXISTS bio TEXT,
  ADD COLUMN IF NOT EXISTS skills VARCHAR(500),
  ADD COLUMN IF NOT EXISTS linkedin_url VARCHAR(500),
  ADD COLUMN IF NOT EXISTS credits INT NOT NULL DEFAULT 0;

ALTER TABLE Applications
  ADD COLUMN IF NOT EXISTS linkedin_url VARCHAR(500),
  ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE Collaborations
  ADD COLUMN IF NOT EXISTS selected_applicant_id INT NULL,
  ADD COLUMN IF NOT EXISTS completed_at DATETIME NULL,
  ADD COLUMN IF NOT EXISTS credit_points INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS StudentWorks (
  work_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  mime_type VARCHAR(120) DEFAULT 'application/octet-stream',
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX(student_id)
);

CREATE TABLE IF NOT EXISTS ProfileLikes (
  like_id INT AUTO_INCREMENT PRIMARY KEY,
  liker_id INT NOT NULL,
  target_id INT NOT NULL,
  target_role VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_profile_like(liker_id,target_id,target_role),
  INDEX(target_id,target_role)
);

CREATE TABLE IF NOT EXISTS CreatorRatings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  creator_id INT NOT NULL,
  student_id INT NOT NULL,
  collab_id INT NOT NULL,
  rating TINYINT NOT NULL,
  review TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_collab_rating(student_id,collab_id),
  INDEX(creator_id)
);

CREATE TABLE IF NOT EXISTS CreditTransactions (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  creator_id INT NOT NULL,
  collab_id INT NOT NULL,
  points INT NOT NULL,
  note VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX(student_id),
  INDEX(creator_id)
);

ALTER TABLE Applications ADD COLUMN IF NOT EXISTS work_id INT NULL;

-- Workflow states used by the creator acceptance/completion flow:
-- OPEN -> IN_PROGRESS (creator accepts one applicant) -> COMPLETED (creator transfers credits).
-- Existing Applications.status and Collaborations.status columns already support these values.
