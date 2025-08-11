--黒作竹光(neet)
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Gains 0 ATK
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(0)
	c:RegisterEffect(e0)   
	--Destroy Spell/Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1) 
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
s.listed_series={0x60}
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	return bc and bc:IsPreviousControler(1-tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x60),tp,LOCATION_MZONE,0,1,e:GetHandler()) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end