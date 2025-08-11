--恶魔蔷薇龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(s.drcon)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
s.listed_names={TOKEN_ROSE}
s.listed_series={0x123}
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_ROSE,0x123,TYPES_TOKEN,800,800,2,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_ROSE,0x123,TYPES_TOKEN,800,800,2,RACE_PLANT,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,TOKEN_ROSE)
		Duel.SpecialSummon(token,0x20,tp,tp,false,false,POS_FACEUP)
	end

	local c=e:GetHandler()
	--Cannot Special Summon from the Extra Deck, except Fusion Monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.target)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Clock Lizard check
	aux.addTempLizardCheck(c,tp,function(_e,_c) return not _c:IsRace(RACE_PLANT) or not (_c:IsType(TYPE_SYNCHRO) and _c:IsSetCard(0x123)) end)
end
function s.target(e,c)
	return (not c:IsRace(RACE_PLANT) or not (c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x123))) and c:IsLocation(LOCATION_EXTRA)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsSetCard(0x123) --and rc:IsAttackAbove(800)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if chk==0 then return rc:IsOnField() end
	Duel.SetTargetCard(rc)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc:IsRelateToEffect(e) then
		local atk=math.abs(rc:UpdateAttack(-rc:GetBaseAttack(),nil,c))
		local ct=atk//800
		if ct~=0 then Duel.Draw(tp,ct,REASON_EFFECT) end
	end
end