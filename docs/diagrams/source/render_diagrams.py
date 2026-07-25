"""Reproducibly render FitVision AI Phase 0 diagrams using Pillow.

This is documentation tooling only. It does not form part of the application.
Run from the repository root: python3 docs/diagrams/source/render_diagrams.py
"""

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import textwrap

ROOT = Path(__file__).resolve().parents[1]
FONT_REG = "/usr/share/fonts/TTF/JetBrainsMonoNLNerdFontPropo-Regular.ttf"
FONT_BOLD = "/usr/share/fonts/TTF/JetBrainsMonoNLNerdFontPropo-Bold.ttf"
BG, INK, MUTED = "#F7FAFC", "#16324F", "#506579"
BLUE, BLUE2, TEAL, GREEN = "#DCEBFA", "#AFCFEC", "#CDEFE8", "#DDF3DD"
GOLD, RED, WHITE, LINE = "#FFF0C2", "#FADBD8", "#FFFFFF", "#7892A8"


def font(size, bold=False):
    return ImageFont.truetype(FONT_BOLD if bold else FONT_REG, size)


def canvas(size, title, subtitle):
    im = Image.new("RGB", size, BG)
    d = ImageDraw.Draw(im)
    d.text((60, 35), title, fill=INK, font=font(38, True))
    d.text((60, 85), subtitle, fill=MUTED, font=font(19))
    d.line((60, 122, size[0] - 60, 122), fill=BLUE2, width=3)
    return im, d


def box(d, xy, title, body="", fill=WHITE, outline=LINE, title_size=22, body_size=16):
    x1, y1, x2, y2 = xy
    d.rounded_rectangle(xy, radius=16, fill=fill, outline=outline, width=3)
    if body:
        d.text((x1 + 18, y1 + 14), title, fill=INK, font=font(title_size, True))
        width = max(12, int((x2 - x1 - 36) / (body_size * 0.61)))
        lines = textwrap.wrap(body, width=width)
        d.multiline_text((x1 + 18, y1 + 50), "\n".join(lines), fill=MUTED,
                         font=font(body_size), spacing=6)
    else:
        bbox = d.textbbox((0, 0), title, font=font(title_size, True))
        d.text(((x1 + x2 - (bbox[2] - bbox[0])) / 2,
                (y1 + y2 - (bbox[3] - bbox[1])) / 2 - 3), title,
               fill=INK, font=font(title_size, True))


def arrow(d, start, end, label="", color=LINE, width=4, label_offset=(0, -28)):
    d.line((*start, *end), fill=color, width=width)
    import math
    angle = math.atan2(end[1] - start[1], end[0] - start[0])
    length = 14
    for delta in (2.55, -2.55):
        p = (end[0] + length * math.cos(angle + delta),
             end[1] + length * math.sin(angle + delta))
        d.line((*end, *p), fill=color, width=width)
    if label:
        mx = (start[0] + end[0]) / 2 + label_offset[0]
        my = (start[1] + end[1]) / 2 + label_offset[1]
        bbox = d.textbbox((0, 0), label, font=font(14, True))
        pad = 5
        d.rounded_rectangle((mx - pad, my - pad, mx + bbox[2] + pad,
                             my + bbox[3] + pad), radius=5, fill=BG)
        d.text((mx, my), label, fill=INK, font=font(14, True))


def architecture():
    im, d = canvas((1800, 1100), "FitVision AI — System Architecture",
                   "Planning view • camera/pose processing remains on-device • only structured data synchronizes")
    # Boundaries
    d.rounded_rectangle((210, 160, 1170, 1000), 24, fill="#F0F7FD", outline=BLUE2, width=4)
    d.text((235, 175), "ANDROID DEVICE / ON-DEVICE TRUST BOUNDARY", fill="#26648E", font=font(20, True))
    d.rounded_rectangle((1210, 160, 1740, 1000), 24, fill="#F3FBF7", outline="#79B7A7", width=4)
    d.text((1235, 175), "CLOUD SERVICES", fill="#277A67", font=font(20, True))

    box(d, (30, 425, 180, 570), "User", "camera, controls, and running", GOLD, title_size=22, body_size=14)
    box(d, (260, 250, 560, 365), "Flutter mobile UI", "screens • feedback • results", BLUE)
    box(d, (660, 250, 1055, 365), "ViewModels / use cases", "session orchestration • policies", BLUE)
    box(d, (260, 455, 560, 570), "Camera service", "frames remain on device", TEAL)
    box(d, (660, 430, 1055, 595), "Kotlin native bridge", "Pigeon / typed channel\nMediaPipe Pose Landmarker", TEAL)
    box(d, (660, 675, 1055, 815), "Exercise engine", "versioned state machines\nrep + form structured events", GOLD)
    box(d, (260, 675, 560, 790), "GPS/location service", "points • accuracy • active time", TEAL)
    box(d, (260, 850, 560, 955), "Local SQLite / Drift", "local-first sessions + routes", GREEN)
    box(d, (660, 850, 1055, 955), "Offline sync queue", "stable IDs • retry • idempotency", GREEN)

    box(d, (1260, 250, 1690, 365), "Supabase Auth", "identity and access tokens", TEAL)
    box(d, (1260, 455, 1690, 590), "FastAPI REST API", "authorization • validation\nbusiness logic • sync", BLUE)
    box(d, (1240, 690, 1475, 825), "PostgreSQL", "persistent user and session records", GREEN, title_size=19, body_size=14)
    box(d, (1500, 690, 1710, 825), "Analytics", "rule-based aggregations", GOLD, title_size=18, body_size=14)

    arrow(d, (180, 495), (260, 310), "interacts")
    arrow(d, (560, 310), (660, 310), "commands/state")
    arrow(d, (410, 365), (410, 455), "camera")
    arrow(d, (560, 515), (660, 515), "camera frames", label_offset=(-65, 60))
    arrow(d, (855, 595), (855, 675), "landmarks only")
    arrow(d, (660, 750), (560, 885))
    arrow(d, (410, 790), (410, 850), "route data")
    arrow(d, (560, 905), (660, 905), "enqueue", label_offset=(0, 8))
    arrow(d, (1055, 905), (1260, 530), "structured summaries + route points", color="#277A67", label_offset=(-120, -70))
    arrow(d, (1055, 310), (1260, 308), "auth", color="#277A67")
    arrow(d, (1475, 365), (1475, 455), "validated token")
    arrow(d, (1390, 590), (1390, 690), "records")
    arrow(d, (1500, 755), (1475, 755), "queries", label_offset=(-38, -30))
    d.rounded_rectangle((1225, 880, 1715, 955), 12, fill=RED, outline="#C56C65", width=2)
    d.text((1245, 897), "NO CAMERA-FRAME PATH TO CLOUD", fill="#8C312A", font=font(20, True))
    d.text((1245, 927), "Only authorized structured data crosses the boundary.", fill="#8C312A", font=font(14))
    im.save(ROOT / "system-architecture.png")


def user_flow():
    im, d = canvas((1900, 1540), "FitVision AI — User Flow",
                   "Primary happy paths with permission, sensor, offline, retry, and logout recovery branches")
    # Shared top flow
    top = [(80, 170, 250, 235, "Splash"), (310, 170, 560, 235, "Authentication check"),
           (620, 155, 860, 250, "Login / Register\n(if required)"),
           (920, 155, 1190, 250, "Permission onboarding"), (1270, 170, 1440, 235, "Home")]
    for x1,y1,x2,y2,t in top: box(d,(x1,y1,x2,y2),t,fill=BLUE,title_size=19)
    for a,b in zip(top, top[1:]): arrow(d,(a[2],(a[1]+a[3])//2),(b[0],(b[1]+b[3])//2))
    box(d, (1510, 170, 1690, 235), "Logout", fill=RED, title_size=18)
    arrow(d, (1440, 202), (1510, 202))
    arrow(d, (1600, 235), (740, 270), "returns to auth", label_offset=(0, 6))
    box(d, (980, 285, 1190, 360), "Permission denied", "explain • retry/settings", RED, title_size=16, body_size=13)
    arrow(d, (1055, 250), (1080, 285), "denied", label_offset=(8, -8))
    arrow(d, (1190, 325), (1270, 220), "continue safely", label_offset=(8, -20))

    # swimlane headings
    d.rounded_rectangle((45, 405, 925, 1460), 22, fill="#F0F7FD", outline=BLUE2, width=3)
    d.text((70, 425), "EXERCISE PATH", fill="#26648E", font=font(25, True))
    d.rounded_rectangle((975, 405, 1855, 1460), 22, fill="#F3FBF7", outline="#79B7A7", width=3)
    d.text((1000, 425), "RUNNING PATH", fill="#277A67", font=font(25, True))
    arrow(d, (1355, 235), (480, 485), "exercise")
    arrow(d, (1355, 235), (1415, 485), "running")

    ex = [
        (310,475,650,545,"Choose exercise"),(310,580,650,665,"Read camera instructions"),
        (310,700,650,770,"Start countdown"),(310,805,650,890,"Live pose detection"),
        (310,925,650,1010,"Rep counting + feedback"),(310,1045,650,1130,"Pause / resume / end"),
        (310,1165,650,1235,"Workout result"),(310,1270,650,1340,"Local save")]
    for *xy,t in ex: box(d,tuple(xy),t,fill=BLUE if "pose" not in t.lower() else TEAL,title_size=18)
    for a,b in zip(ex,ex[1:]): arrow(d,((a[0]+a[2])//2,a[3]),((b[0]+b[2])//2,b[1]))
    box(d,(65,795,265,890),"No pose detected","pause evaluation\nreposition / retry",RED,title_size=15,body_size=13)
    arrow(d,(310,845),(265,845),"lost")
    arrow(d,(165,795),(310,735),"recovered",label_offset=(-15,-22))

    run = [
        (1245,475,1585,545,"Start run"),(1245,580,1585,665,"Check location permission"),
        (1245,700,1585,785,"Live GPS tracking"),(1245,820,1585,905,"Pause / resume / end"),
        (1245,940,1585,1010,"Running result"),(1245,1045,1585,1115,"Local save")]
    for *xy,t in run: box(d,tuple(xy),t,fill=TEAL,title_size=18)
    for a,b in zip(run,run[1:]): arrow(d,((a[0]+a[2])//2,a[3]),((b[0]+b[2])//2,b[1]))
    box(d,(1615,575,1825,665),"Location denied","explain • settings\nreturn safely",RED,title_size=15,body_size=13)
    arrow(d,(1585,622),(1615,622),"denied",label_offset=(-24,-55))
    box(d,(1615,700,1825,790),"GPS unavailable","keep session\ndegraded / retry",RED,title_size=15,body_size=13)
    arrow(d,(1585,742),(1615,742),"loss",label_offset=(-20,-55))

    # Shared completion/sync at bottom middle-right to minimize crossings
    box(d,(1000,1170,1210,1240),"Offline queue",fill=GOLD,title_size=17)
    box(d,(1000,1300,1210,1370),"Synchronization",fill=GREEN,title_size=16)
    box(d,(1450,1170,1755,1240),"History / analytics",fill=GOLD,title_size=17)
    arrow(d,(650,1305),(1000,1205),"saved pending",label_offset=(0,-15))
    arrow(d,(1415,1115),(1210,1205),"saved pending",label_offset=(-20,-20))
    arrow(d,(1105,1240),(1105,1300),"online")
    arrow(d,(1210,1335),(1450,1205),"success")
    arrow(d,(1105,1370),(930,1405),"offline / retry", color="#C98216", label_offset=(-25,-30))
    arrow(d,(930,1405),(1000,1205),"later", color="#C98216", label_offset=(-35,-10))
    arrow(d,(1755,1205),(1805,1205),"Home",label_offset=(-5,-28))
    im.save(ROOT / "user-flow.png")


def erd():
    im, d = canvas((1900, 1450), "FitVision AI — Conceptual Database ERD",
                   "Phase 0 planning model • PK = primary key • FK = foreign key • cardinalities shown on relationships")

    entities = {
        "profiles": ((70,180,560,455), ["PK  id : UUID", "display_name : text", "preferred_units : enum", "created_at : timestamp"]),
        "exercise_definitions": ((700,180,1210,495), ["PK  id : UUID", "name : text", "supported_view : text", "rule_version : text", "is_active : boolean"]),
        "workout_sessions": ((690,615,1240,1085), ["PK  id : UUID (client-stable)", "FK  user_id → profiles.id", "FK  exercise_id → exercise_definitions.id", "started_at : timestamp", "completed_at : timestamp", "total_reps : integer", "valid_reps : integer", "invalid_reps : integer", "form_score : decimal?", "rule_version : text"]),
        "rep_events": ((1350,680,1830,1055), ["PK  id : UUID", "FK  workout_session_id", "    → workout_sessions.id", "rep_number : integer", "duration_ms : integer", "is_valid : boolean", "form_issues : structured data"]),
        "running_sessions": ((70,610,570,1010), ["PK  id : UUID (client-stable)", "FK  user_id → profiles.id", "started_at : timestamp", "completed_at : timestamp", "distance_meters : decimal", "duration_seconds : integer", "average_pace : decimal", "maximum_speed : decimal"]),
        "running_points": ((90,1080,670,1410), ["PK  id : UUID", "FK  running_session_id → running_sessions.id", "sequence_number : integer", "latitude / longitude : decimal", "accuracy_meters : decimal", "recorded_at : timestamp"]),
    }
    colors = {"profiles":BLUE,"exercise_definitions":GOLD,"workout_sessions":BLUE,
              "rep_events":TEAL,"running_sessions":GREEN,"running_points":TEAL}
    for name,(xy,fields) in entities.items():
        x1,y1,x2,y2=xy
        d.rounded_rectangle(xy,16,fill=colors[name],outline=LINE,width=3)
        d.rectangle((x1,y1,x2,y1+52),fill=INK)
        d.text((x1+18,y1+12),name,fill=WHITE,font=font(23,True))
        d.multiline_text((x1+20,y1+70),"\n".join(fields),fill=INK,font=font(17),spacing=10)
    # Orthogonal-ish relations and clear cardinality labels
    arrow(d,(315,455),(315,610),"1        has        0..*",color="#26648E",label_offset=(-110,-28))
    arrow(d,(955,495),(955,615),"1        has        0..*",color="#C98216",label_offset=(-115,-28))
    arrow(d,(1240,850),(1350,850),"1        has        0..*",color="#277A67",label_offset=(-70,-30))
    arrow(d,(395,1010),(395,1080),"1        has        0..*",color="#277A67",label_offset=(-110,-30))
    # Profile-to-workouts relation arrives from left without crossing run relation
    d.line((560,380,620,380,620,745,690,745),fill="#26648E",width=4)
    arrow(d,(620,745),(690,745),color="#26648E")
    d.text((575,345),"1",fill=INK,font=font(18,True)); d.text((625,705),"0..*",fill=INK,font=font(18,True))
    d.text((1390,1160),"Conceptual only — no Phase 0 migrations",fill="#8C312A",font=font(18,True))
    im.save(ROOT / "database-erd.png")


if __name__ == "__main__":
    ROOT.mkdir(parents=True, exist_ok=True)
    architecture()
    user_flow()
    erd()
    print("Rendered system-architecture.png, user-flow.png, database-erd.png")
