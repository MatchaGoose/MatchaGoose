import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Github, Linkedin } from "lucide-react";
import { BsTwitterX } from "react-icons/bs";

interface SocialLinksProps {
  formData: {
    linkedin: string;
    github: string;
    x: string;
  };
  onUpdate: (field: string, value: string) => void;
}

export function SocialLinks({ formData, onUpdate }: SocialLinksProps) {
  return (
    <div className="w-full space-y-4 sm:space-y-6">
      <h2 className="text-lg sm:text-xl font-semibold">Social Links</h2>

      <div className="space-y-4">
        <div className="space-y-2">
          <Label htmlFor="linkedin" className="flex items-center gap-2">
            <Linkedin className="w-4 h-4" />
            LinkedIn <span className="text-red-500">*</span>
          </Label>
          <Input
            id="linkedin"
            value={formData.linkedin}
            onChange={(e) => onUpdate("linkedin", e.target.value)}
            placeholder="https://linkedin.com/in/yourusername"
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="github" className="flex items-center gap-2">
            <Github className="w-4 h-4" />
            GitHub <span className="text-red-500">*</span>
          </Label>
          <Input
            id="github"
            value={formData.github}
            onChange={(e) => onUpdate("github", e.target.value)}
            placeholder="https://github.com/yourusername"
          />
        </div>
        <div className="space-y-2">
          <Label htmlFor="x" className="flex items-center gap-2">
            <BsTwitterX className="w-4 h-4" />X
          </Label>
          <Input
            id="x"
            value={formData.x}
            onChange={(e) => onUpdate("x", e.target.value)}
            placeholder="https://x.com/yourusername"
          />
        </div>
      </div>
    </div>
  );
}
