--No.53 偽骸神 Heart－eartH
local s, id = GetID()
function s.initial_effect(c)
	aux.EnableCheckRankUp(c,nil,nil,23998625)
	--xyz summon
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23998625,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetOperation(s.repop)
	e2:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetCode(EFFECT_RANKUP_EFFECT)
	e22:SetLabelObject(e2)
	c:RegisterEffect(e22)

	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23998625,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	e3:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_SINGLE)
	e32:SetCode(EFFECT_RANKUP_EFFECT)
	e32:SetLabelObject(e3)
	c:RegisterEffect(e32)

	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28106077,0))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(Cost.DetachFromSelf(1))
	e4:SetTarget(s.cd)
	e4:SetOperation(s.op)
	local e42=Effect.CreateEffect(c)
	e42:SetType(EFFECT_TYPE_SINGLE)
	e42:SetCode(EFFECT_RANKUP_EFFECT)
	e42:SetLabelObject(e4)
	c:RegisterEffect(e42)
	local e41=Effect.CreateEffect(c)
	e41:SetDescription(aux.Stringid(28106077,0))
	e41:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e41:SetCategory(CATEGORY_RECOVER)
	e41:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e41:SetCode(EVENT_BATTLE_DAMAGE)
	e41:SetCost(Cost.DetachFromSelf(1))
	e41:SetTarget(s.cd3)
	e41:SetOperation(s.op)
	local e412=Effect.CreateEffect(c)
	e412:SetType(EFFECT_TYPE_SINGLE)
	e412:SetCode(EFFECT_RANKUP_EFFECT)
	e412:SetLabelObject(e41)
	c:RegisterEffect(e412)

	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)

	--battle damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(18158397,0))
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(Cost.DetachFromSelf(1))
	e6:SetTarget(s.cd2)
	e6:SetOperation(s.op2)
	local e62=Effect.CreateEffect(c)
	e62:SetType(EFFECT_TYPE_SINGLE)
	e62:SetCode(EFFECT_RANKUP_EFFECT)
	e62:SetLabelObject(e6)
	c:RegisterEffect(e62)
end
s.xyz_number=53
s.listed_series = {0x48}
s.listed_names={23998625,97403510}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.filter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and a and a:IsRelateToBattle() then
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetValue(s.eqlimit)
		tc:RegisterEffect(e0)
		local atk=a:GetAttack()
		if atk<0 then atk=0 end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1) 
	end
end

function s.value(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local value=0
	if g:GetCount()==0 then
		value=0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if val>=0 and val<888888 then value=val end
		if val>=888888 then value=888888 end
	end
	return value
end

function s.repfilter(c,tc)
	return tc==c:GetEquipTarget()
end 
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ttp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.repfilter,ttp,LOCATION_SZONE,0,1,nil,c) end
	  local atk=c:GetAttack()
	  local atk2=c:GetBaseAttack()
	if Duel.SelectYesNo(ttp,aux.Stringid(23998625,2)) then
		local g=Duel.SelectMatchingCard(ttp,s.repfilter,ttp,LOCATION_SZONE,0,1,1,nil,c)
		if #g<1 then return end
		if Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT+REASON_REPLACE)>0 then
			local diff=0
			if atk>=atk2 then diff=atk-atk2 end 
			if atk2>atk then diff=atk2-atk end 
			Duel.SetTargetPlayer(1-ttp)
			Duel.SetTargetParam(diff)
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,diff)
		end
		return true
	else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.cd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==1-tp
		 and (re and re:GetHandler()==e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.cd3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==1-tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,ev,REASON_EFFECT)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()==0
end
function s.spfilter(c,e,tp)
	return c:IsCode(97403510) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	if chk==0 then return #pg<=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	if #pg>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local cg=Group.FromCards(c)
		tc:SetMaterial(cg)
		Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end

function s.cd2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,ev,REASON_EFFECT)
end
