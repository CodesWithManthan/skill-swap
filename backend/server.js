const express = require("express");
const cors = require("cors"); // Added CORS import
const { Pool } = require("pg");

const app = express();

// Enable CORS and JSON parsing middleware
app.use(cors());
app.use(express.json());

// Configure Database Connection Pool
const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "skillsswap_db",
  password: "manth8027@M",
  port: 5432,
});

pool.connect((err, client, release) => {
  if (err) {
    return console.error("Error acquiring client from pool:", err.stack);
  }
  console.log("Successfully connected to PostgreSQL Database! 🎉");
  release();
});

// Root Route
app.get("/", (req, res) => {
  res
    .status(200)
    .send("Welcome to the SkillSwap Backend Server API Gateway! 🚀");
});

// Health check
app.get("/api/v1/health", (req, res) => {
  res.status(200).json({ status: "success", message: "Server is healthy" });
});

// 1. Fetch Home Feed Skills
app.get("/api/v1/skills", async (req, res) => {
  try {
    const queryText = `
      SELECT 
        skills.id AS "id", 
        skills.title AS "title", 
        skills.category AS "category", 
        skills.description AS "description", 
        skills.status AS "status", 
        skills.wants_text AS "wantsText",
        skills.user_id AS "ownerId",
        users.name AS "userName"
      FROM skills
      JOIN users ON skills.user_id = users.id;
    `;

    const result = await pool.query(queryText);

    res.status(200).json({
      status: "success",
      results: result.rows.length,
      data: result.rows,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({
      status: "error",
      message: "Something went wrong while fetching skills data.",
    });
  }
});

// 2. Create Skill Listing
app.post("/api/v1/skills", async (req, res) => {
  try {
    const { user_id, title, category, description, status, wants_text } =
      req.body;

    const queryText = `
      INSERT INTO skills (user_id, title, category, description, status, wants_text)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *;
    `;

    const values = [user_id, title, category, description, status, wants_text];
    const result = await pool.query(queryText, values);

    res.status(201).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 3. Create User Account
app.post("/api/v1/users", async (req, res) => {
  try {
    const { name, email, bio, college, location } = req.body;

    const queryText = `
      INSERT INTO users (name, email, bio, college, location)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING *;
    `;

    const values = [name, email, bio, college, location];
    const result = await pool.query(queryText, values);

    res.status(201).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 4. Send a Request
app.post("/api/v1/requests", async (req, res) => {
  try {
    const { sender_id, skill_id, session_type, proposed_text } = req.body;

    const queryText = `
      INSERT INTO requests (sender_id, skill_id, session_type, proposed_text)
      VALUES ($1, $2, $3, $4)
      RETURNING *;
    `;

    const values = [sender_id, skill_id, session_type, proposed_text];
    const result = await pool.query(queryText, values);

    res.status(201).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 5. GET Incoming Requests (Fixed Aliases for Flutter)
app.get("/api/v1/requests/incoming/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const queryText = `
      SELECT 
        r.id AS "id", 
        r.status AS "status", 
        r.session_type AS "sessionType", 
        r.proposed_text AS "proposedText",
        s.title AS "skillTitle",
        u.name AS "senderName", 
        u.college AS "senderCollege"
      FROM requests r
      JOIN skills s ON r.skill_id = s.id
      JOIN users u ON r.sender_id = u.id
      WHERE s.user_id = $1
      ORDER BY r.id DESC;
    `;

    const result = await pool.query(queryText, [userId]);

    res.status(200).json({
      status: "success",
      results: result.rows.length,
      data: result.rows,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 6. GET Sent / Outgoing Requests (Fixed Aliases for Flutter)
app.get("/api/v1/requests/sent/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const queryText = `
      SELECT 
        r.id AS "id", 
        r.status AS "status", 
        r.session_type AS "sessionType", 
        r.proposed_text AS "proposedText",
        s.title AS "skillTitle",
        u.name AS "receiverName", 
        u.college AS "receiverCollege"
      FROM requests r
      JOIN skills s ON r.skill_id = s.id
      JOIN users u ON s.user_id = u.id
      WHERE r.sender_id = $1
      ORDER BY r.id DESC;
    `;

    const result = await pool.query(queryText, [userId]);

    res.status(200).json({
      status: "success",
      results: result.rows.length,
      data: result.rows,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 7. Update Request Status
app.patch("/api/v1/requests/:requestId/status", async (req, res) => {
  try {
    const { requestId } = req.params;
    const { status } = req.body;

    const queryText = `
      UPDATE requests
      SET status = $1
      WHERE id = $2
      RETURNING *;
    `;

    const result = await pool.query(queryText, [status, requestId]);

    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "Request not found" });
    }

    res.status(200).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// 8. User Profile & Experiences
app.get("/api/v1/users/:id", async (req, res) => {
  try {
    const { id } = req.params;

    const query = `
      SELECT 
        u.id,
        u.name,
        u.email,
        u.college,
        u.location,
        u.bio,
        u.tagline,
        UPPER(LEFT(SPLIT_PART(u.name, ' ', 1), 1) || COALESCE(LEFT(SPLIT_PART(u.name, ' ', 2), 1), '')) AS "avatarInitials",
        COALESCE(u.avatar_color_index, 0)::INT AS "avatarColorIndex",
        COALESCE(u.total_swaps, 0)::INT AS "totalSwaps",
        COALESCE(u.rating, 5.0)::FLOAT AS rating,
        COALESCE(u.review_couont, 0)::INT AS "reviewCount",
        s.title AS "offers",
        s.wants_text AS "wants"
      FROM users u
      LEFT JOIN skills s ON s.user_id = u.id
      WHERE u.id = $1
      LIMIT 1;
    `;

    const result = await pool.query(query, [id]);

    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ status: "error", message: "User not found" });
    }


    const activeCountQuery = `
      SELECT COUNT(*) AS count
      FROM requests r
      LEFT JOIN skills s ON r.skill_id = s.id
      WHERE (r.sender_id = $1 OR s.user_id = $1)
      AND r.status = 'pending';
    `;

    const activeResult = await pool.query(activeCountQuery, [id]);
    const activeRequests = parseInt(activeResult.rows[0].count, 10);


    res.status(200).json({
      status: "success",
      data: {
        ...result.rows[0],
        activeRequests,
      },
    });
  } catch (err) {
    console.error("Error fetching user profile:", err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});



// 9. Update User Profile
app.patch("/api/v1/users/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { name, bio, college, location, tagline } = req.body;

    const queryText = `
      UPDATE users
      SET 
        name = COALESCE($1, name),
        bio = COALESCE($2, bio),
        college = COALESCE($3, college),
        location = COALESCE($4, location),
        tagline = COALESCE($5, tagline)
      WHERE id = $6
      RETURNING *;
    `;

    const values = [name, bio, college, location, tagline, id];
    const result = await pool.query(queryText, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ status: "error", message: "User not found" });
    }

    res.status(200).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

app.get("/api/v1/experiences/:userId", async (req, res) => {
  try {
    const { userId } = req.params;

    const queryText = `
      SELECT id, title, organization, duration 
      FROM experiences 
      WHERE user_id = $1 
      ORDER BY created_at DESC;
    `;

    const result = await pool.query(queryText, [userId]);

    res.status(200).json({
      status: "success",
      results: result.rows.length,
      data: result.rows,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

app.post("/api/v1/experiences", async (req, res) => {
  try {
    const { user_id, title, organization, duration } = req.body;

    const queryText = `
      INSERT INTO experiences (user_id, title, organization, duration)
      VALUES ($1, $2, $3, $4)
      RETURNING *;
    `;

    const values = [user_id, title, organization, duration];
    const result = await pool.query(queryText, values);

    res.status(201).json({
      status: "success",
      data: result.rows[0],
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ status: "error", message: err.message });
  }
});

// Start Server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
