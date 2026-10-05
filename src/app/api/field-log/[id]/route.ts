import { deleteRep, updateRep } from "@/app/(app)/field-log/actions";
import { formOf, readBody } from "@/lib/api/forms";
import { apiRoute, ApiError, redirectTarget } from "@/lib/api/route";

/** Edits a logged rep. Moving it to another skill moves its XP with it, as on the website. */
export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;
    const body = await readBody(request);

    try {
      const result = await updateRep(
        {},
        formOf({
          id,
          skill_id: body.skillId,
          went: body.went,
          context_note: body.contextNote,
          reflection: body.reflection,
          other_sex: body.otherSex,
          other_age_group: body.otherAgeGroup,
        }),
      );
      if (result?.error) throw new ApiError(422, "rejected", result.error);
    } catch (error) {
      // Success redirects to /field-log?edited=1.
      if (!redirectTarget(error)) throw error;
    }

    return { ok: true };
  });
}

/** Deletes a logged rep, takes its XP back, and works the streak out again. */
export async function DELETE(request: Request, { params }: { params: Promise<{ id: string }> }) {
  return apiRoute(request, async () => {
    const { id } = await params;

    try {
      await deleteRep(formOf({ id }));
    } catch (error) {
      const target = redirectTarget(error);
      if (!target) throw error;
      // `?error=1` is the one failing outcome; the others are success or already gone.
      if (target.includes("error=1")) throw new ApiError(500, "delete_failed");
    }

    return { ok: true };
  });
}
