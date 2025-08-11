--风化番兵(neet)
local s,id=GetID()
function s.initial_effect(c)
	-- Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(Cost.SelfBanish)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.sdop)
		Duel.RegisterEffect(ge1,0)
	end
end
s.listed_names={CARD_FOSSIL_FUSION}
function s.filter(c)
	return c:IsOriginalCodeRule(59419719,100000025)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(s.filter,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)==0 and tc:IsOriginalCodeRule(100000025) then
			--activate
			local e1=Fusion.CreateSummonEff({handler=tc,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x14c),matfilter=Fusion.OnFieldMat,extrafil=s.fextra,value=0x20,extraop=Fusion.BanishMaterial,extratg=s.extratg})
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCondition(function(e) return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0 end)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,0,0,1)
		end
		if tc:GetFlagEffect(id)==0 and tc:IsOriginalCodeRule(59419719) then
			--activate
			local e1=Fusion.CreateSummonEff({handler=tc,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x14c),matfilter=Fusion.OnFieldMat,extrafil=s.fextra,
												stage2=s.stage2,extraop=Fusion.BanishMaterial,extratg=s.extratarget})
			tc:RegisterEffect(e1)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCondition(function(e) return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0 end)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,0,0,1)
		end
		tc=g:GetNext()
	end
end

function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)
	else
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_ONFIELD,0,nil)
	end
	return nil
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE+LOCATION_MZONE)
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==3 then
		local mats=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
		if mats:IsExists(Card.IsPreviousControler,1,nil,tp) and mats:IsExists(Card.IsPreviousControler,1,nil,1-tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3003)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.tgval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
	end
end
function s.desfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and (c:IsControler(1-tp)
		or (c:IsFaceup() and c:IsRace(RACE_ROCK)))
end
function s.desrescon(sg,e,tp,mg)
	return sg:FilterCount(Card.IsControler,nil,tp)==1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  and aux.SelectUnselectGroup(rg,e,tp,2,2,s.desrescon,0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,s.desrescon,1,tp,HINTMSG_DESTROY)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)==2 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
end