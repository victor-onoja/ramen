import { Resolver, Query, UseMiddleware } from "type-graphql";
import { InjectRepository } from "typeorm-typedi-extensions";
import { UserRepository } from "../../../repository/user/UserRepository";
import { User } from "../../../../entity/User";

@Resolver((of) => User)
class GetUsersResolver {
	@InjectRepository(UserRepository)
	private readonly userRepository: UserRepository;

	@UseMiddleware()
	@Query(() => [User], { nullable: true })
	async getUsers() {
		const users = await this.userRepository.find({
			relations: ["followers", "following"],
		});

		return users;
	}
}

export default GetUsersResolver;
