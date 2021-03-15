import { Authorized, Field, ID, ObjectType, Root } from "type-graphql";
import {
	Entity,
	Column,
	PrimaryColumn,
	BeforeInsert,
	BaseEntity,
	ManyToMany,
} from "typeorm";
import { v4 as uuidv4 } from "uuid";
import * as bcrypt from "bcrypt";
import { UserStatus } from "../shared/UserStatus.enum";
import { UserRole } from "../shared/UserRole.enum";

@ObjectType("UserSchema")
@Entity("User")
export class User extends BaseEntity {
	@Field(() => ID)
	@PrimaryColumn("uuid")
	id: string;

	@Field(() => String!)
	@Column("text", { unique: true })
	email: string;

	// @Authorized(UserRole.super_admin)
	@Field(() => String!)
	@Column()
	password: string;

	@Field(() => String!)
	@Column({ nullable: true })
	firstName: string;

	@Field(() => String!)
	@Column({ nullable: true })
	lastName: string;

	@Field(() => UserStatus!)
	@Column("text", { nullable: true, default: UserStatus.none })
	status: UserStatus;

	// External
	@Field(() => String!)
	name(@Root() parent: User): string {
		return `${parent.firstName} ${parent.lastName}`;
	}

	@BeforeInsert()
	async addId() {
		this.id = uuidv4();
	}

	@BeforeInsert()
	async hashPassword() {
		this.password = await bcrypt.hash(this.password, 10);
	}
}
