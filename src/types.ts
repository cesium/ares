export interface CompatibilityItem {
  icon: string;
  title: string;
}

export interface FeatureItem {
  description: string;
  icon: string;
  title: string;
}

export interface FooterLink {
  description: string;
  icon: string;
  url: string;
}

export interface NavItem {
  title: string;
  url: string;
}

export interface FaqItem {
  question: string;
  answer: string;
}

export interface RegisterItem {
  name: string;
  email: string;
  mobile: string;
  age: number;
  confirmation: string;
  university: string;
  course: string;
  team_code: string;
  notes: string;
  vegan: boolean;
}

export interface CreateTeamItem {
  team_name: string;
  member_email: string;
  new_team_code: string;
}

export interface JoinTeamItem {
  team_code: string;
  member_email: string;
}

export interface SubmitProjectItem {
  team_code: string;
  name: string;
  description: string;
  link: string;
}

export interface SideBarOption {
  title: string;
  url: string;
}
