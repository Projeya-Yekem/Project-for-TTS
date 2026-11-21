# دليل المساهمة وسير العمل الجماعي — Kurmanji-TTS

- **الفرع الرئيسي (`main`):** محمي؛ يُمنع الدفع المباشر عليه دون مراجعة.
- **الفروع:** يعمل كل عضو على فرع ميزة مستقل (مثل `feat/ui-polish` أو `fix/tts-chunking`) ثم يفتح Pull Request.
- **شروط الدمج:** مراجعة عضو واحد على الأقل + نجاح فحص GitHub Actions (`Unit Tests` على Windows وUbuntu).
- **تعديل الكود والاختبارات:** أي تعديل في `text_utils.py` أو `tts_engine.py` أو `audio_player.py` يجب أن يرافقه اختبار وحدة في `tests/test_kurmanji_tts.py`.
- **تعديل الأطروحة:** لا تعدّل `docs/Kurmanji-TTS_Thesis_Rojava.docx` يدوياً؛ عدّل `scripts/thesis_*.py` ثم شغّل `python scripts/build_thesis.py` و`python scripts/audit_docx.py`.
