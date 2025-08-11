local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--cannot special summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87997872,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	--indestructible
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCode(EFFECT_IMMUNE_EFFECT) 
	e4:SetValue(s.efilter) 
	c:RegisterEffect(e4)

	--End Phase Win
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCost(s.atkcost1)
	e5:SetCondition(s.wincon)
	e5:SetOperation(s.winop)
	c:RegisterEffect(e5,false,EFFECT_MARKER_DETACH_XMAT)

	--自己场上怪兽不能成为攻击目标
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTarget(s.beatktg)
	e7:SetValue(Auxiliary.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	
	--negate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetOperation(s.negop1)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_BE_BATTLE_TARGET)
	e10:SetOperation(s.negop2)
	c:RegisterEffect(e10)
end
s.xyz_number=100
s.listed_names={494}
s.listed_series = {0x48}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.beatktg(e,c)
	return c~=e:GetHandler()
end

function s.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.cfilter(c,tp,code)
	return c:IsCode(code) and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,494)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and eg:IsExists(s.cfilter,1,nil,tp,494) then
	local g=eg:Filter(s.cfilter,nil,tp,494)
	e:GetHandler():SetMaterial(g)
	Duel.Overlay(e:GetHandler(),g)
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
	e:GetHandler():CompleteProcedure() end
end

function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(Duel.GetTurnPlayer(),ACTIVITY_ATTACK)==0 
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_CiNo100=0x52
	Duel.Win(1-Duel.GetTurnPlayer(),WIN_REASON_CiNo100)
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d then
		local atk=d:GetAttack()
		--c:CreateRelation(d,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		--e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		--e2:SetCondition(s.discon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		--e3:SetCondition(s.discon)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(atk*2)
		--e4:SetCondition(s.discon)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e4) 
	end
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d then
		--c:CreateRelation(d,RESET_EVENT+0x1fe0000)
		local atk=d:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		--e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		--e2:SetCondition(s.discon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		--e3:SetCondition(s.discon)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(atk*2)
		--e4:SetCondition(s.discon)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4) 
	end
end
function s.discon(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end